from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt

MU = 0.01  # linear mass density [kg/m]
TENSION = 100.0  # string tension [N]
B = 0.5  # friction coefficient [N*s/m^2], beta = B / (2 * MU)
L = 1.0
M = 100  # number of spatial nodes
N = 2000  # number of time levels

s = lambda x: -2 * x**2 + 0.8 * x + 0.92  # y(x, 0)
g = lambda x: np.sin(2 * np.pi * x)  # dy/dt(x, 0)
H = 0.8  # dy/dx(0, t)
R = -0.28  # y(L, t)

V = np.sqrt(TENSION / MU)  # wave velocity
DX = L / (M - 1)
DT = DX / V  # CFL condition: dt <= dx / v
X = np.linspace(0.0, L, M)
T = np.arange(N) * DT


def simulate(beta: float) -> np.ndarray:
    # y[k, m] = y(x_m, t_k)
    p = (V * DT / DX) ** 2
    q = 1 + beta * DT
    u = 1 - beta * DT

    y = np.zeros((N, M))
    y[0] = s(X)

    # First time step (ghost node y(-1) eliminated with the initial velocity)
    y[1, 1:-1] = p / 2 * (y[0, 2:] - 2 * y[0, 1:-1] + y[0, :-2]) + y[0, 1:-1] + u * DT * g(X[1:-1])
    y[1, 0] = p * (y[0, 1] - y[0, 0] - DX * H) + y[0, 0] + u * DT * g(X[0])
    y[1, -1] = R

    # Next time steps
    for k in range(1, N - 1):
        y[k + 1, 1:-1] = (
            p / q * (y[k, 2:] - 2 * y[k, 1:-1] + y[k, :-2])
            + 2 / q * y[k, 1:-1]
            - u / q * y[k - 1, 1:-1]
        )
        y[k + 1, 0] = (
            2 * p / q * (y[k, 1] - y[k, 0] - DX * H) + 2 / q * y[k, 0] - u / q * y[k - 1, 0]
        )
        y[k + 1, -1] = R
    return y


def plot_surface(y: np.ndarray, title: str, path: Path) -> None:
    x_grid, t_grid = np.meshgrid(X, T)
    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(projection="3d")
    ax.plot_surface(x_grid, t_grid, y, cmap="viridis", linewidth=0, rcount=200, ccount=M)
    ax.set_xlabel("x [m]")
    ax.set_ylabel("t [s]")
    ax.set_zlabel("y [m]")
    ax.set_title(title)
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)


def plot_equilibrium(y_last: np.ndarray, y_eq: np.ndarray, path: Path) -> None:
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.plot(X, y_last, label="last iteration")
    ax.plot(X, y_eq, "--", label="equilibrium")
    ax.set_xlabel("x [m]")
    ax.set_ylabel("y [m]")
    ax.set_title(f"Last iteration (t = {T[-1]:.4f} s) vs equilibrium solution")
    ax.legend()
    ax.grid(True)
    fig.savefig(path, dpi=150, bbox_inches="tight")
    plt.close(fig)


def main() -> None:
    folder = Path(__file__).parent
    beta = B / (2 * MU)
    print(f"v = {V:g} m/s, dx = {DX:.6f} m, dt = {DT:.3e} s, t_max = {T[-1]:.4f} s, beta = {beta:g} 1/s")

    y_free = simulate(0.0)
    plot_surface(y_free, "String vibration without damping ($\\beta = 0$)", folder / "string_beta_0.png")

    y_damped = simulate(beta)
    plot_surface(y_damped, f"String vibration with damping ($\\beta = {beta:g}$)", folder / "string_beta_damped.png")

    # Equilibrium: y_E'' = 0, y_E'(0) = H, y_E(L) = R  ->  y_E = H x + (R - H L)
    y_eq = H * X + (R - H * L)
    print(f"y_E(x) = {H:g} x + ({R - H * L:g})")
    print(f"max |y_last - y_E| (damped) = {np.abs(y_damped[-1] - y_eq).max():.4f}")
    print(f"max |y_last - y_E| (no damping) = {np.abs(y_free[-1] - y_eq).max():.4f}")
    plot_equilibrium(y_damped[-1], y_eq, folder / "equilibrium.png")


if __name__ == "__main__":
    main()
