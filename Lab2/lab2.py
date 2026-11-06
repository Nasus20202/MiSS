from dataclasses import dataclass
from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt

f = lambda x, y: x * y + x + y
f_x = lambda x, y: y + 1  # df/dx
f_y = lambda x, y: x + 1  # df/dy

X_0 = 0.0
Y_0 = 0.0
Z_0 = 200.0

V_0_X = 5.0
V_0_Y = 5.01
V_0_Z = 0.0

K = 0.9

G = 10.0
M = 1.0
BOUNCE_COUNT = 5
SURFACE_HALF_SIZE = 60.0  # half-width of the x/y range of the whole-surface panel
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

    # For surface f(x, y) = x * y + x + y, we solve the quadratic equation for collision time
    a = v_0_x * v_0_y + 0.5 * G
    b = x_0 * v_0_y + y_0 * v_0_x + v_0_x + v_0_y - v_0_z
    c = x_0 * y_0 + x_0 + y_0 - z_0

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


def plot_two_panel_overview(
    bounces: list[Bounce],
    loss_factor: float,
    path: Path,
    half_size: float = SURFACE_HALF_SIZE,
) -> None:
    paths = [
        position(b.start_point, b.start_velocity, np.linspace(0.0, b.dt, 200))
        for b in bounces
    ]
    all_points = np.concatenate(paths, axis=1)

    fig = plt.figure(figsize=(18, 9))

    # Left panel: whole surface over a wide x/y range, z auto-scaled
    x_grid, y_grid = np.meshgrid(
        np.linspace(-half_size, half_size, 200),
        np.linspace(-half_size, half_size, 200),
    )
    ax_whole = fig.add_subplot(1, 2, 1, projection="3d")
    ax_whole.plot_surface(x_grid, y_grid, f(x_grid, y_grid), cmap="viridis", alpha=0.45, linewidth=0)
    for i, (x, y, z) in enumerate(paths, start=1):
        ax_whole.plot3D(x, y, z, linewidth=2, label=f"bounce {i}")
    ax_whole.set_xlabel("x")
    ax_whole.set_ylabel("y")
    ax_whole.set_zlabel("z")
    ax_whole.set_title(f"Whole surface (x, y in [{-half_size:g}, {half_size:g}])", pad=15)
    ax_whole.legend(fontsize=8)

    # Right panel: zoom on the bounces, with equal scale on x, y and z
    x_min, x_max = all_points[0].min() - 2, all_points[0].max() + 2
    y_min, y_max = all_points[1].min() - 2, all_points[1].max() + 2
    z_min, z_max = all_points[2].min() - 10, all_points[2].max() + 10
    x_zoom, y_zoom = np.meshgrid(
        np.linspace(x_min, x_max, 150),
        np.linspace(y_min, y_max, 150),
    )
    ax_zoom = fig.add_subplot(1, 2, 2, projection="3d")
    ax_zoom.plot_surface(x_zoom, y_zoom, f(x_zoom, y_zoom), cmap="viridis", alpha=0.45, linewidth=0)
    for i, (x, y, z) in enumerate(paths, start=1):
        ax_zoom.plot3D(x, y, z, linewidth=2, label=f"bounce {i}")
    for b in bounces:
        ax_zoom.scatter(*b.impact_point, s=20)
    ax_zoom.set_xlim(x_min, x_max)
    ax_zoom.set_ylim(y_min, y_max)
    ax_zoom.set_zlim(z_min, z_max)
    ax_zoom.set_box_aspect((x_max - x_min, y_max - y_min, z_max - z_min))  # 1:1:1 data scale
    ax_zoom.set_xlabel("x")
    ax_zoom.set_ylabel("y")
    ax_zoom.set_zlabel("z")
    ax_zoom.set_title(f"Zoom on bounces (k = {loss_factor}, equal x, y, z scale)", pad=15)

    fig.savefig(path, dpi=130, bbox_inches="tight")
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
        plot_two_panel_overview(
            bounces,
            loss_factor,
            Path(__file__).with_name(f"two_panel_overview_k_{loss_factor}.png"),
        )


if __name__ == "__main__":
    main()
