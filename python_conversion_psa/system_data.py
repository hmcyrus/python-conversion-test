"""
system_data.py
Converted from: ieee_4bus_3ph_3_4wire.m

Defines the IEEE 4-bus 3-phase 4-wire test system.
Returns a dict 'sd' (system data) containing all network parameters,
bus/line tables, and initial voltage/load vectors.
"""

import numpy as np


def build_system():
    # ------------------------------------------------------------------
    # Base values
    # ------------------------------------------------------------------
    kVA_base = 2000e3          # 2000 kVA base
    kV_baseH = (12.47 / np.sqrt(3)) * 1e3
    kV_baseL = (4.16  / np.sqrt(3)) * 1e3
    Z_baseH  = (kV_baseH ** 2) / kVA_base
    Z_baseL  = (kV_baseL ** 2) / kVA_base
    I_baseL  = kVA_base / kV_baseL

    # ------------------------------------------------------------------
    # Transformer (single-phase equivalent series impedance, pu)
    # ------------------------------------------------------------------
    Trf_Z = 0.01 + 0.06j
    Trf_Y = 1.0 / Trf_Z

    # 6×6 LTC primitive admittance matrix
    LTC_Y = Trf_Y * np.array([
        [ 1,  0,  0, -1,  0,  0],
        [ 0,  1,  0,  0, -1,  0],
        [ 0,  0,  1,  0,  0, -1],
        [-1,  0,  0,  1,  0,  0],
        [ 0, -1,  0,  0,  1,  0],
        [ 0,  0, -1,  0,  0,  1],
    ], dtype=complex)

    Ykk = 1.0 / Trf_Z
    Ymm = Ykk
    Ykm = -Ykk
    Ymk = Ykm

    # LTC entry: [from_bus, to_bus, Y6x6, tap_init, tap_max, tap_min,
    #             tap_steps, tap_current]
    ltc = [
        {
            'from':    1,
            'to':      2,
            'Y':       LTC_Y,
            'tap':     np.array([1.0, 1.0, 1.0]),
            'tap_max': np.array([1.5, 1.5, 1.5]),
            'tap_min': np.array([0.5, 0.5, 0.5]),
            'tap_steps': 2,
            'tap_cur': np.array([1.000, 1.000, 1.000]),
        }
    ]

    # ------------------------------------------------------------------
    # Load multipliers / scaling
    # ------------------------------------------------------------------
    LDM  = 1.0
    PPL  = -1.0
    p_P  = 1.00;  p_I = 0.0;  p_Z = 0.0
    q_P  = 1.00;  q_I = 0.0;  q_Z = 0.0
    PPL_a = 1.0;  PPL_b = 1.0;  PPL_c = 1.0

    # load_P / load_Q scaling vectors (4 phases × n_buses, all ones here)
    n_buses = 4
    load_P = np.ones(4 * n_buses)
    load_Q = np.ones(4 * n_buses)
    pv_curve_reshape_factor = np.ones(4 * n_buses)

    # ------------------------------------------------------------------
    # Bus table
    # Each row: bus_no, V_init(4), A_init(4), PL(4), QL(4),
    #           PG(4), QG(4), PZ(4), QZ(4), PI(4), QI(4),
    #           SR(4), SI(4), bus_type, DGP(4), DGQ(4)
    #
    # Convention: phases a,b,c = indices 0,1,2 ; neutral = index 3
    # Bus types: 1=slack, 2=PV, 3=PQ
    # ------------------------------------------------------------------
    ang0 = np.array([0.0, -2*np.pi/3,  2*np.pi/3, 0.0])
    V0   = np.array([1.0,  1.0,        1.0,        0.0])
    z4   = np.zeros(4)
    pf   = 0.9
    PL_rated = 1.80
    QL_rated = PL_rated * np.tan(np.arccos(pf))

    buses = [
        # Bus 1 — slack
        {'no': 1, 'V': V0.copy(), 'A': ang0.copy(),
         'PL': z4.copy(), 'QL': z4.copy(),
         'PG': z4.copy(), 'QG': z4.copy(),
         'PZ': z4.copy(), 'QZ': z4.copy(),
         'PI': z4.copy(), 'QI': z4.copy(),
         'SR': z4.copy(), 'SI': z4.copy(),
         'type': 1,
         'DGP': z4.copy(), 'DGQ': z4.copy()},

        # Bus 2 — PQ, no load
        {'no': 2, 'V': V0.copy(), 'A': ang0.copy(),
         'PL': z4.copy(), 'QL': z4.copy(),
         'PG': z4.copy(), 'QG': z4.copy(),
         'PZ': z4.copy(), 'QZ': z4.copy(),
         'PI': z4.copy(), 'QI': z4.copy(),
         'SR': z4.copy(), 'SI': z4.copy(),
         'type': 3,
         'DGP': z4.copy(), 'DGQ': z4.copy()},

        # Bus 3 — PQ, no load
        {'no': 3, 'V': V0.copy(), 'A': ang0.copy(),
         'PL': z4.copy(), 'QL': z4.copy(),
         'PG': z4.copy(), 'QG': z4.copy(),
         'PZ': z4.copy(), 'QZ': z4.copy(),
         'PI': z4.copy(), 'QI': z4.copy(),
         'SR': z4.copy(), 'SI': z4.copy(),
         'type': 3,
         'DGP': z4.copy(), 'DGQ': z4.copy()},

        # Bus 4 — PQ, 50% rated load on phases a,b,c
        {'no': 4, 'V': V0.copy(), 'A': ang0.copy(),
         'PL': 0.5 * np.array([PL_rated, PL_rated, PL_rated, 0.0]),
         'QL': 0.5 * np.array([QL_rated, QL_rated, QL_rated, 0.0]),
         'PG': z4.copy(), 'QG': z4.copy(),
         'PZ': z4.copy(), 'QZ': z4.copy(),
         'PI': z4.copy(), 'QI': z4.copy(),
         'SR': z4.copy(), 'SI': z4.copy(),
         'type': 3,
         'DGP': z4.copy(), 'DGQ': z4.copy()},
    ]

    # ------------------------------------------------------------------
    # Line impedance data (Kersting 4-wire Carson equations, Ω/mile)
    # ------------------------------------------------------------------
    z_3w_3ph = np.array([
        [0.4013+1j*1.4133, 0.0953+1j*0.8515, 0.0953+1j*0.7266],
        [0.0953+1j*0.8515, 0.4013+1j*1.4133, 0.0953+1j*0.7802],
        [0.0953+1j*0.7266, 0.0953+1j*0.7802, 0.4013+1j*1.4133],
    ], dtype=complex)

    z_4w_3ph = np.array([
        [0.4013+1j*1.4133, 0.0953+1j*0.8515, 0.0953+1j*0.7266, 0.0953+1j*0.7524],
        [0.0953+1j*0.8515, 0.4013+1j*1.4133, 0.0953+1j*0.7802, 0.0953+1j*0.7865],
        [0.0953+1j*0.7266, 0.0953+1j*0.7802, 0.4013+1j*1.4133, 0.0953+1j*0.7674],
        [0.0953+1j*0.7524, 0.0953+1j*0.7865, 0.0953+1j*0.7674, 0.6873+1j*1.5465],
    ], dtype=complex)

    # Line 1-2: 3-wire section (no neutral row/col), 2000 ft, normalised
    z_line_12_3w = (z_3w_3ph / (1760 * 3)) * 2000
    z_line_12_3w = z_line_12_3w / Z_baseH

    # Embed in 4×4 (neutral row/col = 0 → floating neutral on HV side)
    z_line_12 = np.zeros((4, 4), dtype=complex)
    z_line_12[:3, :3] = z_line_12_3w

    y_line_12 = np.zeros((4, 4), dtype=complex)
    y_line_12[:3, :3] = np.linalg.inv(z_line_12_3w)

    # Line 2-3: transformer branch.
    # NOTE: In the original MATLAB code this is zeros(4,4) — the transformer
    # admittance was left disconnected (commented-out lines in ieee_4bus_3ph_3_4wire.m).
    # Without this connection buses 3-4 form an isolated subsystem with no
    # voltage reference, causing unphysical voltages.
    # Set USE_TRANSFORMER = True to wire in the transformer (trf_Y_4x4),
    # which gives physically meaningful LV voltages at buses 3-4.
    USE_TRANSFORMER = False   # set True to activate transformer branch
    y_line_23 = np.zeros((4, 4), dtype=complex)
    if USE_TRANSFORMER:
        # grounded-wye/grounded-wye single-phase equivalent (diagonal per phase)
        trf_Y_3ph = np.diag([Trf_Y, Trf_Y, Trf_Y, 0.0]).astype(complex)
        y_line_23 = trf_Y_3ph

    # Line 3-4: 3-wire section, 2500 ft, LV base
    z_line_34_3w = (z_3w_3ph / (1760 * 3)) * 2500
    z_line_34_3w = z_line_34_3w / Z_baseL

    z_line_34 = np.zeros((4, 4), dtype=complex)
    z_line_34[:3, :3] = z_line_34_3w

    y_line_34 = np.zeros((4, 4), dtype=complex)
    y_line_34[:3, :3] = np.linalg.inv(z_line_34_3w)

    # ------------------------------------------------------------------
    # Transformer 4×4 primitive admittance matrix
    # (grounded-wye / grounded-wye, neutral tied)
    # ------------------------------------------------------------------
    trf_Y_4x4 = np.diag([Trf_Y, Trf_Y, Trf_Y, 3*Trf_Y]).astype(complex)
    trf_Y_4x4[3, :3] = -Trf_Y
    trf_Y_4x4[:3, 3] = -Trf_Y

    # ------------------------------------------------------------------
    # Line table
    # Each entry: from_bus, to_bus, Y_series (4×4), Y_shunt/2 (4×4)
    # ------------------------------------------------------------------
    lines = [
        {'from': 1, 'to': 2, 'Y': y_line_12, 'B': np.zeros((4, 4), dtype=complex)},
        {'from': 2, 'to': 3, 'Y': y_line_23, 'B': np.zeros((4, 4), dtype=complex)},
        {'from': 3, 'to': 4, 'Y': y_line_34, 'B': np.zeros((4, 4), dtype=complex)},
    ]

    # ------------------------------------------------------------------
    # 3-wire / 4-wire bus classification (excluding slack)
    # ind_3w_bus: buses whose neutral is floating (no 4th wire equation)
    # ind_4w_bus: buses with explicit neutral conductor
    # ------------------------------------------------------------------
    tot_3w_bus = 2
    ind_3w_bus = [2, 3, 4]   # 1-indexed, excluding slack
    ind_4w_bus = []

    # ------------------------------------------------------------------
    # Wye-Delta operator (Kersting)
    # ------------------------------------------------------------------
    D = np.array([
        [ 1, -1,  0],
        [ 0,  1, -1],
        [-1,  0,  1],
    ], dtype=float)

    # ------------------------------------------------------------------
    # Assemble and return
    # ------------------------------------------------------------------
    return dict(
        # base values
        kVA_base=kVA_base, kV_baseH=kV_baseH, kV_baseL=kV_baseL,
        Z_baseH=Z_baseH, Z_baseL=Z_baseL, I_baseL=I_baseL,
        # transformer
        Trf_Z=Trf_Z, Trf_Y=Trf_Y, LTC_Y=LTC_Y,
        trf_Y_4x4=trf_Y_4x4,
        # load scaling
        LDM=LDM, PPL=PPL,
        p_P=p_P, p_I=p_I, p_Z=p_Z,
        q_P=q_P, q_I=q_I, q_Z=q_Z,
        load_P=load_P, load_Q=load_Q,
        # network
        buses=buses, lines=lines, ltc=ltc,
        tot_3w_bus=tot_3w_bus, ind_3w_bus=ind_3w_bus, ind_4w_bus=ind_4w_bus,
        # raw impedance matrices (for reference/debug)
        z_3w_3ph=z_3w_3ph, z_4w_3ph=z_4w_3ph,
        z_line_12=z_line_12, z_line_34=z_line_34,
        y_line_12=y_line_12, y_line_23=y_line_23, y_line_34=y_line_34,
        # misc
        D=D,
    )
