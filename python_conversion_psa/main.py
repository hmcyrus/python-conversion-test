"""
main.py
Converted from: nrci3ph4w.m

Entry point for the 3-phase 4-wire Newton-Raphson Current-Injection
(NRCI) power flow solver.

Run:
    python main.py
"""

import numpy as np
from system_data import build_system
from ymatrix import build_ymatrix
from nr_iteration import nr_step


def run_powerflow(max_iter=50, tol=1e-6):
    # Step 1 — load system data
    state = build_system()

    # Step 2 — build Y matrix and initialise flat bus vectors
    state = build_ymatrix(state)

    # Step 3 — Newton-Raphson loop
    for iteration in range(1, max_iter + 1):
        state, dI = nr_step(state)
        mismatch = np.max(np.abs(dI))
        print(f"  iter {iteration:3d}   max|dI| = {mismatch:.4e}")
        if mismatch <= tol:
            print(f"\nConverged in {iteration} iteration(s).")
            break
    else:
        print(f"\nDid NOT converge after {max_iter} iterations.")

    # ------------------------------------------------------------------
    # Print results
    # ------------------------------------------------------------------
    busV    = state['busV']
    busA    = state['busA']
    bus_ind = state['bus_ind']
    tot_bus = state['tot_bus']

    print("\n--- Bus Voltage Results ---")
    print(f"{'Bus':>4}  {'Phase':>6}  {'|V| (pu)':>10}  {'Angle (deg)':>12}")
    phase_labels = ['a', 'b', 'c', 'n']
    for b in range(tot_bus):
        for p in range(4):
            idx = 4 * b + p
            print(f"{bus_ind[b]:>4}  {phase_labels[p]:>6}  "
                  f"{busV[idx]:>10.6f}  {np.degrees(busA[idx]):>12.4f}")
        print()

    return state


if __name__ == '__main__':
    run_powerflow()
