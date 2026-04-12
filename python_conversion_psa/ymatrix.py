"""
ymatrix.py
Converted from: ymat_3ph3_4w.m

Builds the full nodal admittance matrix Y for a 3-phase 4-wire system
from the system data dict returned by system_data.build_system().

Returns the input dict augmented with:
    Y, G, B          - full (4*n_bus × 4*n_bus) nodal admittance matrix
    busV, busA       - flat voltage magnitude / angle vectors (4*n_bus,)
    busPL, busQL     - constant-power load vectors
    busPZ, busQZ     - constant-impedance load vectors
    busPI, busQI     - constant-current load vectors
    busPG, busQG     - generation vectors
    busDGP, busDGQ   - DG vectors
    busBTP           - battery/storage vector
    bus_ind          - array of bus numbers
    bus_typ_ind      - array of bus types (1=slack,2=PV,3=PQ)
    pq_ind, pv_ind, swing_ind - 0-based indices into the bus list
    aaa,bbb,ccc,ddd  - phase-index helper arrays (0-based)
    num_f, num_t     - 0-based from/to bus indices for each line
    zyind            - indices of zero diagonal elements in Y
    idxLP,idxLQ,...  - non-zero load element indices
"""

import numpy as np


def build_ymatrix(sd):
    buses   = sd['buses']
    lines   = sd['lines']
    LDM     = sd['LDM']
    PPL     = sd['PPL']
    p_P     = sd['p_P'];  p_Z = sd['p_Z'];  p_I = sd['p_I']
    q_P     = sd['q_P'];  q_Z = sd['q_Z'];  q_I = sd['q_I']
    load_P  = sd['load_P']
    load_Q  = sd['load_Q']

    n_ph    = 4
    tot_bus = len(buses)
    tot_line = len(lines)

    # ------------------------------------------------------------------
    # Flat bus arrays  (length = 4 * tot_bus)
    # ------------------------------------------------------------------
    bus_ind     = np.array([b['no']   for b in buses], dtype=int)
    bus_typ_ind = np.array([b['type'] for b in buses], dtype=int)

    def flat(key):
        return np.concatenate([b[key] for b in buses])

    busV  = flat('V').astype(float)
    busA  = flat('A').astype(float)

    busPL = p_P * LDM * (load_P * flat('PL'))
    busQL = q_P * LDM * (load_Q * flat('QL'))
    busPG = flat('PG').astype(float)
    busQG = flat('QG').astype(float)
    busPZ = p_Z * LDM * (load_P * flat('PZ'))
    busQZ = q_Z * LDM * (load_Q * flat('QZ'))
    busPI = p_I * LDM * (load_P * flat('PI'))
    busQI = q_I * LDM * (load_Q * flat('QI'))
    busSR = flat('SR').astype(float)
    busSI = flat('SI').astype(float)
    busDGP = PPL * flat('DGP')
    busDGQ = 0.00 * (np.tan(np.arccos(0.97)) * busDGP)
    busBTP = np.zeros(4 * tot_bus)

    # Save originals (used inside NR iteration for ZIP model)
    busP0L = busPL.copy()
    busQ0L = busQL.copy()
    busP0Z = busPZ.copy()
    busQ0Z = busQZ.copy()
    busP0I = busPI.copy()
    busQ0I = busQI.copy()

    # Phase index helpers (0-based)
    aaa = 4 * np.arange(tot_bus)          # phase a indices
    bbb = 4 * np.arange(tot_bus) + 1      # phase b
    ccc = 4 * np.arange(tot_bus) + 2      # phase c
    ddd = 4 * np.arange(tot_bus) + 3      # neutral

    # ------------------------------------------------------------------
    # Map line from/to bus numbers → 0-based indices into buses list
    # ------------------------------------------------------------------
    num_f = np.zeros(tot_line, dtype=int)
    num_t = np.zeros(tot_line, dtype=int)
    for i, ln in enumerate(lines):
        num_f[i] = np.where(bus_ind == ln['from'])[0][0]
        num_t[i] = np.where(bus_ind == ln['to'])[0][0]

    # ------------------------------------------------------------------
    # Build block Y matrix as (tot_bus × tot_bus) list of 4×4 blocks
    # ------------------------------------------------------------------
    Y_blk = [[np.zeros((4, 4), dtype=complex) for _ in range(tot_bus)]
             for _ in range(tot_bus)]

    # Off-diagonal blocks: -y_series
    for i in range(tot_line):
        f = num_f[i];  t = num_t[i]
        Y_blk[f][t] += lines[i]['Y']
        Y_blk[t][f]  = Y_blk[f][t].copy()

    # Diagonal blocks: sum of all connected branch admittances
    # Step 1: accumulate off-diagonal column sums into a helper
    Y_sum = [[np.zeros((4, 4), dtype=complex) for _ in range(tot_bus)]
             for _ in range(tot_bus)]
    for i in range(tot_bus):
        for j in range(tot_bus):
            Y_sum[i][j] = Y_blk[i][j].copy()

    # Running column sum (MATLAB: Y_dummy{l,m} += Y_dummy{l-1,m})
    for m in range(tot_bus):
        for l in range(1, tot_bus):
            Y_sum[l][m] = Y_sum[l][m] + Y_sum[l-1][m]

    # Add accumulated column sum to diagonal; negate off-diagonals
    for i in range(tot_bus):
        for j in range(tot_bus):
            if i == j:
                Y_blk[i][j] = Y_blk[i][j] + Y_sum[tot_bus - 1][j]
            else:
                Y_blk[i][j] = -Y_blk[i][j]

    # Line charging (shunt B/2 on each terminal)
    for i in range(tot_bus):
        for k in range(tot_line):
            if num_f[k] == i or num_t[k] == i:
                Y_blk[i][i] += 0.5 * lines[k]['B']

    # ------------------------------------------------------------------
    # Assemble full matrix
    # ------------------------------------------------------------------
    Y = np.block([[Y_blk[i][j] for j in range(tot_bus)]
                  for i in range(tot_bus)])

    # ------------------------------------------------------------------
    # Neutral-row/column handling:
    # For 3-wire buses (floating neutral) zero out the 4th row/col.
    # ind_3w_bus is 1-indexed in the original MATLAB code.
    # ------------------------------------------------------------------
    ind_3w_bus = sd['ind_3w_bus']           # e.g. [2, 3, 4]  (1-indexed)
    for bus_no in ind_3w_bus:
        idx_0based = np.where(bus_ind == bus_no)[0][0]
        row_col = 4 * idx_0based + 3        # neutral index in flat system
        Y[row_col, :] = 0.0
        Y[:, row_col] = 0.0

    G = Y.real.copy()
    B = Y.imag.copy()

    # Diagnostic: zero-diagonal indices
    dY   = np.diag(Y)
    zyind = np.where(dY == 0)[0]

    # Bus type index arrays (0-based indices into buses list)
    pq_ind    = np.where(bus_typ_ind == 3)[0]
    pv_ind    = np.where(bus_typ_ind == 2)[0]
    swing_ind = np.where(bus_typ_ind == 1)[0]

    # Non-zero load element indices (for selective Jacobian builds)
    idxLP = np.where(busP0L != 0)[0]
    idxLQ = np.where(busQ0L != 0)[0]
    idxZP = np.where(busP0Z != 0)[0]
    idxZQ = np.where(busQ0Z != 0)[0]
    idxIP = np.where(busP0I != 0)[0]
    idxIQ = np.where(busQ0I != 0)[0]

    # ------------------------------------------------------------------
    # Augment system data dict and return
    # ------------------------------------------------------------------
    sd.update(dict(
        tot_bus=tot_bus, tot_line=tot_line,
        n_ph=n_ph,
        bus_ind=bus_ind, bus_typ_ind=bus_typ_ind,
        busV=busV, busA=busA,
        busV0=busV.copy(), busA0=busA.copy(),
        busPL=busPL, busQL=busQL,
        busP0L=busP0L, busQ0L=busQ0L,
        busPG=busPG, busQG=busQG,
        busPZ=busPZ, busQZ=busQZ,
        busP0Z=busP0Z, busQ0Z=busQ0Z,
        busPI=busPI, busQI=busQI,
        busP0I=busP0I, busQ0I=busQ0I,
        busSR=busSR, busSI=busSI,
        busDGP=busDGP, busDGQ=busDGQ,
        busBTP=busBTP,
        Y=Y, G=G, B=B,
        dY=dY, zyind=zyind,
        aaa=aaa, bbb=bbb, ccc=ccc, ddd=ddd,
        num_f=num_f, num_t=num_t,
        pq_ind=pq_ind, pv_ind=pv_ind, swing_ind=swing_ind,
        idxLP=idxLP, idxLQ=idxLQ,
        idxZP=idxZP, idxZQ=idxZQ,
        idxIP=idxIP, idxIQ=idxIQ,
    ))
    return sd
