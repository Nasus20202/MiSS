from dataclasses import dataclass
from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt

f = lambda x, y: x**2 + y**2
f_x = lambda x, y: 2 * x  # df/dx
f_y = lambda x, y: 2 * y  # df/dy

X_0 = -5.0
Y_0 = 0.0
Z_0 = 200.0

V_0_X = 2.0
V_0_Y = 4.0
V_0_Z = 0.0

K = 0.8

G = 10.0
M = 1.0
BOUNCE_COUNT = 5
EPS = 1e-9  # rounding error threshold for floating point comparisons


@dataclass
class Bounce:
    start_point: np.ndarray
    start_velocity: np.ndarray
    impact_point: np.ndarray
    dt: float
    kinetic_energy: float
    potential_energy: float
    total_energy: float

    def __str__(self) -> str:
        x, y, z = self.impact_point
        return (
            f"impact = ({x:.4f}, {y:.4f}, {z:.4f}), dt = {self.dt:.4f}, "
            f"kinetic_energy = {self.kinetic_energy:.4f}, "
            f"potential_energy = {self.potential_energy:.4f}, "
            f"total_energy = {self.total_energy:.4f}"
        )


def velocity(starting_velocity: np.ndarray, t: float) -> np.ndarray:
    v_x = starting_velocity[0]
    v_y = starting_velocity[1]
    v_z = starting_velocity[2] - G * t
    return np.array([v_x, v_y, v_z])


def position(
    starting_point: np.ndarray, starting_velocity: np.ndarray, t: float
) -> np.ndarray:
    x = starting_point[0] + starting_velocity[0] * t
    y = starting_point[1] + starting_velocity[1] * t
    z = starting_point[2] + starting_velocity[2] * t - 0.5 * G * t**2
    return np.array([x, y, z])


def calculate_collision_time(
    starting_point: np.ndarray, starting_velocity: np.ndarray
) -> float:
    x_0, y_0, z_0 = starting_point
    v_0_x, v_0_y, v_0_z = starting_velocity

    # For surface f(x, y) = x^2 + y^2, we solve the quadratic equation for collision time
    a = -0.5 * G - v_0_x**2 - v_0_y**2
    b = v_0_z - 2 * x_0 * v_0_x - 2 * y_0 * v_0_y
    c = z_0 - x_0**2 - y_0**2

    roots = np.roots([a, b, c])
    real_roots = roots[np.abs(roots.imag) < EPS].real
    positive_roots = real_roots[real_roots > EPS]
    if len(positive_roots) == 0:
        raise ValueError("No positive roots found for collision time.")
    return float(np.max(positive_roots))


def bounce_velocity(
    point: np.ndarray, velocity: np.ndarray, loss_factor: float
) -> np.ndarray:
    x, y, z = point
    fx = f_x(x, y)
    fy = f_y(x, y)
    normal = np.array([-fx, -fy, 1.0])
    normal /= np.linalg.norm(normal)
    v_after = velocity - 2 * np.dot(velocity, normal) * normal
    return np.sqrt(loss_factor) * v_after


def kinetic_energy(vel: np.ndarray) -> float:
    return 0.5 * M * np.dot(vel, vel)


def potential_energy(height: float) -> float:
    return M * G * height


def simulate(
    starting_point: np.ndarray,
    starting_velocity: np.ndarray,
    loss_factor: float,
    bounce_count: int,
) -> list[Bounce]:
    point = starting_point
    current_velocity = starting_velocity
    bounces = []
    for _ in range(bounce_count):
        collision_time = calculate_collision_time(point, current_velocity)
        impact = position(point, current_velocity, collision_time)
        vel_before = velocity(current_velocity, collision_time)

        kinetic = kinetic_energy(vel_before)
        potential = potential_energy(impact[2])
        bounces.append(
            Bounce(
                start_point=point,
                start_velocity=current_velocity,
                impact_point=impact,
                dt=collision_time,
                kinetic_energy=kinetic,
                potential_energy=potential,
                total_energy=kinetic + potential,
            )
        )

        current_velocity = bounce_velocity(impact, vel_before, loss_factor)
        point = impact
    return bounces


def plot_bounces(bounces: list[Bounce], loss_factor: float, path: Path) -> None:
    # Flight path of each bounce: position(start, start velocity, t) for t in [0, dt]
    paths = [
        position(b.start_point, b.start_velocity, np.linspace(0.0, b.dt, 200))
        for b in bounces
    ]
    all_x = np.concatenate([p[0] for p in paths])
    all_y = np.concatenate([p[1] for p in paths])
    x_grid, y_grid = np.meshgrid(
        np.linspace(all_x.min() - 1, all_x.max() + 1, 100),
        np.linspace(all_y.min() - 1, all_y.max() + 1, 100),
    )

    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(projection="3d")
    ax.plot_surface(x_grid, y_grid, f(x_grid, y_grid), cmap="viridis", alpha=0.35)
    for i, (x, y, z) in enumerate(paths, start=1):
        ax.plot3D(x, y, z, linewidth=2, label=f"bounce {i}")
    ax.set_xlabel("x")
    ax.set_ylabel("y")
    ax.set_zlabel("z")
    ax.set_title(f"Surface and bounce paths (k = {loss_factor})")
    ax.legend()
    fig.savefig(path, dpi=150)
    plt.close(fig)


def main() -> None:
    starting_point = np.array([X_0, Y_0, Z_0])
    starting_velocity = np.array([V_0_X, V_0_Y, V_0_Z])
    for loss_factor in [1.0, K]:
        bounces = simulate(starting_point, starting_velocity, loss_factor, BOUNCE_COUNT)
        print(f"k = {loss_factor}:")
        for i, b in enumerate(bounces, start=1):
            print(f"  Bounce {i}: {b}")
        plot_bounces(
            bounces,
            loss_factor,
            Path(__file__).with_name(f"trajectories_k_{loss_factor}.png"),
        )


if __name__ == "__main__":
    main()
