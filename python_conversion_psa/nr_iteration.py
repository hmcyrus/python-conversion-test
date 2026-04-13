"""
nr_iteration.py
Converted from: curr_mm_3p3_4w.m

Performs one Newton-Raphson Current-Injection (NRCI) iteration for a
3-phase 4-wire power flow.

Algorithm summary
-----------------
1. Compute complex bus voltages V = Vr + jVm from busV, busA.
2. Calculate specified injected currents I from P/Q specs (phase-to-neutral).
   Neutral current is the negative sum of the three phase currents.
3. Compute current mismatch: dIr, dIm = I_specified - Y*V (real/imag parts).
4. Build the current-injection Jacobian IJAC (8*tot_bus square, partitioned
   into [B G; G -B] blocks plus load derivative terms efgh).
5. Eliminate rows/cols for slack bus and floating-neutral (3-wire) buses.
6. Solve IJAC * dV = dI for voltage corrections.
7. Update busV, busA, and ZIP load vectors.

Returns
-------
sd  : updated state dict (busV, busA, busPZ, busQZ, busPI, busQI updated)
dI  : current mismatch vector *before* the solve (used for convergence check)
"""

import numpy as np


def nr_step(sd):
    # ------------------------------------------------------------------
    # Unpack state
    # ------------------------------------------------------------------
    tot_bus   = sd['tot_bus']
    G         = sd['G'];    B  = sd['B']
    busV      = sd['busV'].copy()
    busA      = sd['busA'].copy()
    busP0Z    = sd['busP0Z'];  busQ0Z = sd['busQ0Z']
    busP0I    = sd['busP0I'];  busQ0I = sd['busQ0I']
    busP0L    = sd['busP0L'];  busQ0L = sd['busQ0L']
    busPG     = sd['busPG'];   busQG  = sd['busQG']
    busPZ     = sd['busPZ'].copy();  busQZ = sd['busQZ'].copy()
    busPI     = sd['busPI'].copy();  busQI = sd['busQI'].copy()
    busPL     = sd['busPL'];   busQL  = sd['busQL']
    busDGP    = sd['busDGP'];  busDGQ = sd['busDGQ']
    busBTP    = sd['busBTP']
    pv_ind    = sd['pv_ind']
    swing_ind = sd['swing_ind']
    ind_3w_bus = sd['ind_3w_bus']   # 1-indexed bus numbers with floating neutral
    bus_ind    = sd['bus_ind']
    busV0      = sd['busV0']        # initial (reference) voltage magnitudes

    n = 4 * tot_bus   # total number of nodal variables

    # ------------------------------------------------------------------
    # 1. Complex voltages
    # ------------------------------------------------------------------
    V  = busV * np.exp(1j * busA)   # (n,)
    Vr = V.real.copy()
    Vm = V.imag.copy()

    # ------------------------------------------------------------------
    # 2. Net specified power injection  P_spec = PG - PL - PZ - PI - DGP
    # ------------------------------------------------------------------
    busP_spec = busPG - (busPL + busPZ + busPI) - busDGP - busBTP
    busQ_spec = busQG - (busQL + busQZ + busQI) - busDGQ

    # ------------------------------------------------------------------
    # 3. Compute specified injected current  I = (P - jQ) / (V_ph - V_n)*
    #    Phase conductors: complex current formula (phase-to-neutral reference)
    #    Neutral: I_n = -(I_a + I_b + I_c)
    # ------------------------------------------------------------------
    I  = np.zeros(n, dtype=complex)

    for b in range(tot_bus):
        n0 = 4 * b          # base index for bus b
        Vr_n = Vr[n0 + 3]  # neutral real
        Vm_n = Vm[n0 + 3]  # neutral imag
        for p in range(3):  # phases a, b, c
            dVr = Vr[n0 + p] - Vr_n
            dVm = Vm[n0 + p] - Vm_n
            denom = dVr**2 + dVm**2
            I[n0 + p] = (
                (busP_spec[n0 + p] * dVr + busQ_spec[n0 + p] * dVm) / denom
                + 1j *
                (busP_spec[n0 + p] * dVm - busQ_spec[n0 + p] * dVr) / denom
            )
        I[n0 + 3] = -np.sum(I[n0:n0 + 3])   # neutral KCL

    Ir = I.real.copy()
    Im = I.imag.copy()

    # ------------------------------------------------------------------
    # 4. Current calculated from Y*V
    # ------------------------------------------------------------------
    dIr = np.zeros(n)
    dIm = np.zeros(n)

    # Vectorised Y*V product
    IV = G @ Vr - B @ Vm    # real part of Y*V
    QV = G @ Vm + B @ Vr    # imag part of Y*V

    # Mismatch: specified - calculated
    # Phase conductors: full mismatch formula
    # Neutral: direct residual
    for b in range(tot_bus):
        n0   = 4 * b
        Vr_n = Vr[n0 + 3]
        Vm_n = Vm[n0 + 3]
        for p in range(3):
            dVr = Vr[n0 + p] - Vr_n
            dVm = Vm[n0 + p] - Vm_n
            denom = dVr**2 + dVm**2
            Psp = busP_spec[n0 + p]
            Qsp = busQ_spec[n0 + p]
            dIr[n0 + p] = (
                -IV[n0 + p]
                + (Psp * dVr + Qsp * dVm) / denom
            )
            dIm[n0 + p] = (
                -QV[n0 + p]
                + (Psp * dVm - Qsp * dVr) / denom
            )
        # neutral
        dIr[n0 + 3] = -IV[n0 + 3] + Ir[n0 + 3]
        dIm[n0 + 3] = -QV[n0 + 3] + Im[n0 + 3]

    # ------------------------------------------------------------------
    # 5. Load derivative coefficients (ZIP model) for Jacobian
    #    a_L, b_L, c_L, d_L  shape: (n,)  — only phases 0..2 are used
    # ------------------------------------------------------------------
    a_L = np.zeros(n)
    b_L = np.zeros(n)
    c_L = np.zeros(n)
    d_L = np.zeros(n)

    for b in range(tot_bus):
        n0   = 4 * b
        Vr_n = Vr[n0 + 3]
        Vm_n = Vm[n0 + 3]
        for p in range(3):
            dVr  = Vr[n0 + p] - Vr_n
            dVm  = Vm[n0 + p] - Vm_n
            dV2  = dVr**2 + dVm**2
            dV2_sq = dV2**2
            dV3  = dV2**1.5
            Psp  = busP_spec[n0 + p]
            Qsp  = busQ_spec[n0 + p]
            PZ   = busPZ[n0 + p];   QZ = busQZ[n0 + p]
            PI_  = busPI[n0 + p];   QI = busQI[n0 + p]

            # AP, BP, CP, DP: constant-power terms
            AP = (Qsp * (dVr**2 - dVm**2) - 2*dVr*dVm*Psp) / dV2_sq
            BP = (Psp * (dVr**2 - dVm**2) + 2*dVr*dVm*Qsp) / dV2_sq
            CP = (Psp * (dVm**2 - dVr**2) - 2*dVr*dVm*Qsp) / dV2_sq
            DP = (Qsp * (dVr**2 - dVm**2) - 2*dVr*dVm*Psp) / dV2_sq

            # AI, BI, CI, DI: constant-current terms
            AI = (Vr[n0+p]*dVm*PI_ + QI*(dVm**2)) / dV3
            BI = (dVr*dVm*QI + PI_*(dVr**2)) / dV3
            CI = (dVr*dVm*QI - PI_*(dVm**2)) / dV3
            DI = (dVr*dVm*PI_ - QI*(dVr**2)) / dV3

            # AZ, BZ, CZ, DZ: constant-impedance terms
            AZ = QZ;  BZ = PZ;  CZ = PZ;  DZ = QZ

            a_L[n0 + p] =  AP + AI + AZ
            b_L[n0 + p] =  BP - BI - BZ
            c_L[n0 + p] =  CP + CI - CZ
            d_L[n0 + p] =  DP + DI - DZ

    # ------------------------------------------------------------------
    # 6. Build current-injection Jacobian  IJAC  (8*tot_bus × 8*tot_bus)
    #    Layout per bus i:  rows/cols  8i+0..3 = imaginary  (dIm / dVr, dVm)
    #                                 8i+4..7 = real        (dIr / dVr, dVm)
    #
    #    Off-diagonal blocks (bus i ≠ j):
    #        [dIm/dVr  dIm/dVm]   [B_ij   G_ij]
    #        [dIr/dVr  dIr/dVm] = [G_ij  -B_ij]
    #
    #    Diagonal load correction stored in efgh (8×8 per bus)
    # ------------------------------------------------------------------
    n_pv = len(pv_ind)
    IJAC = np.zeros((8*tot_bus + 3*n_pv, 8*tot_bus + 3*n_pv), dtype=float)

    # Off- and on-diagonal Y-based blocks
    for ii in range(tot_bus):
        for jj in range(tot_bus):
            r4 = slice(4*ii, 4*ii+4)
            c4 = slice(4*jj, 4*jj+4)
            # imaginary rows (8ii+0..3), Vr cols (8jj+0..3)
            IJAC[8*ii:8*ii+4, 8*jj:8*jj+4]     +=  B[r4, c4]
            # imaginary rows, Vm cols (8jj+4..7)
            IJAC[8*ii:8*ii+4, 8*jj+4:8*jj+8]   +=  G[r4, c4]
            # real rows (8ii+4..7), Vr cols
            IJAC[8*ii+4:8*ii+8, 8*jj:8*jj+4]   +=  G[r4, c4]
            # real rows, Vm cols
            IJAC[8*ii+4:8*ii+8, 8*jj+4:8*jj+8] += -B[r4, c4]

    # Diagonal load derivative corrections efgh (8×8 per bus)
    for ii in range(tot_bus):
        n0   = 4 * ii
        e = np.zeros((8, 8))
        al = a_L[n0:n0+3]
        bl = b_L[n0:n0+3]
        cl = c_L[n0:n0+3]
        dl = d_L[n0:n0+3]

        # Upper-left 4×4  (dIm/dVr)
        e[0:3, 0:3] = -np.diag(al)
        e[3,   0:3] =  al
        e[0:3, 3]   =  al
        e[3,   3]   = -np.sum(al)
        # Upper-right 4×4  (dIm/dVm)
        e[0:3, 4:7] = -np.diag(bl)
        e[3,   4:7] =  bl
        e[0:3, 7]   =  bl
        e[3,   7]   = -np.sum(bl)
        # Lower-left 4×4  (dIr/dVr)
        e[4:7, 0:3] = -np.diag(cl)
        e[7,   0:3] =  cl
        e[4:7, 3]   =  cl
        e[7,   3]   = -np.sum(cl)
        # Lower-right 4×4  (dIr/dVm)
        e[4:7, 4:7] = -np.diag(dl)
        e[7,   4:7] =  dl
        e[4:7, 7]   =  dl
        e[7,   7]   = -np.sum(dl)

        IJAC[8*ii:8*ii+8, 8*ii:8*ii+8] += e

    # ------------------------------------------------------------------
    # 7. PV bus voltage-magnitude constraints (extra rows/cols)
    # ------------------------------------------------------------------
    for ii in range(n_pv):
        pv   = pv_ind[ii]
        n0   = 4 * pv
        row_base = 8 * tot_bus + 3 * ii
        col_base = 8 * pv
        Vmag = np.abs(Vr[n0:n0+3] + 1j*Vm[n0:n0+3])

        # dV/d(Vr), dV/d(Vm) into extra rows
        IJAC[row_base:row_base+3, col_base:col_base+3] = np.diag(Vr[n0:n0+3] / Vmag)
        IJAC[row_base:row_base+3, col_base+4:col_base+7] = np.diag(Vm[n0:n0+3] / Vmag)

        # transpose into extra cols
        d1 = np.diag(Vr[n0:n0+3] / Vmag**2)
        d2 = np.diag(Vm[n0:n0+3] / Vmag**2)
        dummy1 = np.zeros((3, 8))
        dummy1[:, 0:3] =  d1
        dummy1[:, 4:7] = -d2
        IJAC[col_base:col_base+8, row_base:row_base+3] = dummy1.T

    # ------------------------------------------------------------------
    # 8. Determine rows/cols to eliminate (vanish_ind, 0-based)
    #    Always remove: slack bus rows 0..7
    #    Also remove: neutral rows/cols for 3-wire buses (indices 3 and 7
    #    in the 8-wide block of each 3-wire bus)
    # ------------------------------------------------------------------
    vanish_ind = list(range(8))    # slack bus (bus index 0 in flat array)

    for bus_no in ind_3w_bus:
        bus_0 = int(np.where(bus_ind == bus_no)[0][0])
        vanish_ind.append(8 * bus_0 + 3)   # Vr neutral column block
        vanish_ind.append(8 * bus_0 + 7)   # Vm neutral column block

    vanish_ind = sorted(set(vanish_ind))

    IJAC = np.delete(IJAC, vanish_ind, axis=0)
    IJAC = np.delete(IJAC, vanish_ind, axis=1)

    # ------------------------------------------------------------------
    # 9. Build RHS mismatch vector dI  (length 8*tot_bus, then trimmed)
    # ------------------------------------------------------------------
    dI_full = np.zeros(8 * tot_bus)
    for ii in range(tot_bus):
        dI_full[8*ii:8*ii+4] = dIm[4*ii:4*ii+4]   # imaginary part mismatch
        dI_full[8*ii+4:8*ii+8] = dIr[4*ii:4*ii+4] # real part mismatch

    # PV voltage mismatch appended
    delV_spec = np.zeros(3 * n_pv)
    if n_pv > 0:
        for b in range(n_pv):
            pv   = pv_ind[b]
            n0   = 4 * pv
            delV_spec[3*b:3*b+3] = busV0[n0:n0+3] - busV[n0:n0+3]

    # Remove vanish rows from dI, then append PV spec
    dI = np.delete(dI_full, vanish_ind)
    dI = np.concatenate([dI, delV_spec])

    # ------------------------------------------------------------------
    # 10. Solve for voltage corrections
    # ------------------------------------------------------------------
    dV_sol = np.linalg.solve(IJAC, dI)
    # Strip the PV Lagrange multiplier portion
    dV_sol = dV_sol[:len(dV_sol) - len(delV_spec)]

    # Expand back to full 8*tot_bus vector (zeros at vanish_ind)
    dV1 = np.zeros(8 * tot_bus)
    free_idx = [i for i in range(8 * tot_bus) if i not in set(vanish_ind)]
    for k, idx in enumerate(free_idx):
        dV1[idx] = dV_sol[k]

    # Split into dVr, dVm
    dVr = np.zeros(n)
    dVm = np.zeros(n)
    for ii in range(tot_bus):
        dVr[4*ii:4*ii+4] = dV1[8*ii:8*ii+4]
        dVm[4*ii:4*ii+4] = dV1[8*ii+4:8*ii+8]

    # ------------------------------------------------------------------
    # 11. Update voltage and ZIP load vectors
    # ------------------------------------------------------------------
    Vr_new = Vr + dVr
    Vm_new = Vm + dVm
    V_new  = Vr_new + 1j * Vm_new

    busV_new = np.abs(V_new)
    busA_new = np.angle(V_new)

    busPZ_new = sd['busP0Z'] * (busV_new ** 2)
    busQZ_new = sd['busQ0Z'] * (busV_new ** 2)
    busPI_new = sd['busP0I'] * (busV_new ** 1)
    busQI_new = sd['busQ0I'] * (busV_new ** 1)

    # ------------------------------------------------------------------
    # 12. Write back to state dict
    # ------------------------------------------------------------------
    sd['busV']  = busV_new
    sd['busA']  = busA_new
    sd['busPZ'] = busPZ_new
    sd['busQZ'] = busQZ_new
    sd['busPI'] = busPI_new
    sd['busQI'] = busQI_new

    # Convergence metric: trimmed mismatch vector (slack + floating-neutral rows
    # removed), matching the MATLAB `dI(vanish_ind)=[]` check in curr_mm_3p3_4w.m.
    # dI_full includes the slack-bus rows whose mismatch equals -Y*V (large and
    # grows after iteration 1), which would prevent convergence detection.
    dI_conv = np.delete(dI_full, vanish_ind)
    if len(delV_spec) > 0:
        dI_conv = np.concatenate([dI_conv, delV_spec])
    return sd, dI_conv
