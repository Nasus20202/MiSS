# Lab 2

Ciało odbija się od powierzchni $z = f(x, y)$ w polu grawitacyjnym.

## Dane

- $f(x, y) = x^2 + y^2$
- $g = 10\ \text{m/s}^2$, $m = 1\ \text{kg}$
- start: $(x_0, y_0, z_0) = (-5, 0, 200)$, $\vec{v}_0 = (2, 4, 0)$
- $k = 1$ (zad. 1–2), $k = 0{,}8$ (zad. 3)

## Obliczenia

Moment zderzenia $t_I$:

$$
z_0 + v_{0z} t - \frac{1}{2} g t^2 = f(x_0 + v_{0x} t,\ y_0 + v_{0y} t)
$$

$$
f(x, y) = x^2 + y^2
$$

$$
z_0 + v_{0z} t - \frac{1}{2} g t^2 = (x_0 + v_{0x} t)^2 + (y_0 + v_{0y} t)^2
$$

$$
z_0 + v_{0z} t - \frac{1}{2} g t^2 = x_0^2 + 2 x_0 v_{0x} t + v_{0x}^2 t^2 + y_0^2 + 2 y_0 v_{0y} t + v_{0y}^2 t^2
$$

$$
t^2 \left( -\frac{1}{2} g - v_{0x}^2 - v_{0y}^2 \right) + t \left( v_{0z} - 2 x_0 v_{0x} - 2 y_0 v_{0y} \right) + (z_0 - x_0^2 - y_0^2) = 0
$$

Współczynniki ($a t^2 + b t + c = 0$):

$$
a = -\frac{1}{2} g - v_{0x}^2 - v_{0y}^2 = -25
$$

$$
b = v_{0z} - 2 x_0 v_{0x} - 2 y_0 v_{0y} = 20
$$

$$
c = z_0 - x_0^2 - y_0^2 = 175
$$

Pierwiastki: $t \approx 3{,}0758\ \text{s}$ oraz $t \approx -2{,}2758\ \text{s}$. Ujemny odrzucamy, więc $t_I \approx 3{,}0758\ \text{s}$.

Punkt zderzenia:

$$
x_I = x_0 + v_{0x} t_I, \quad y_I = y_0 + v_{0y} t_I, \quad z_I = z_0 + v_{0z} t_I - \frac{1}{2} g t_I^2
$$

Prędkość przed zderzeniem:

$$
\vec{v}(t) = [v_{0x},\ v_{0y},\ v_{0z} - g t]
$$

Odbicie:

$$
\vec{n} = \frac{\vec{N}}{\|\vec{N}\|}, \qquad \vec{N} = \left[-\frac{\partial f}{\partial x},\ -\frac{\partial f}{\partial y},\ 1\right]
$$

$$
\vec{v}_{\text{po}} = \sqrt{k}\left[\vec{v}_{\text{przed}} - 2 (\vec{v}_{\text{przed}} \cdot \vec{n})\, \vec{n}\right]
$$

Energia ($m = 1\ \text{kg}$), liczona z prędkości tuż przed zderzeniem:

$$
E_{\text{kin}} = \frac{m |\vec{v}|^2}{2}, \qquad E_{\text{pot}} = m g z_I, \qquad E_{\text{całk}} = E_{\text{kin}} + E_{\text{pot}}
$$

## Kod

Plik: `lab2.py`. Uruchomienie:

```
python lab2.py
```

Program wypisuje wyniki dla $k = 1$ i $k = 0{,}8$ oraz zapisuje wykresy `trajectories_k_1.0.png` i `trajectories_k_0.8.png` obok skryptu.

Najważniejsze funkcje: `calculate_collision_time`, `bounce_velocity`, `kinetic_energy`, `potential_energy`, `simulate`, `plot_bounces`.

## Wyniki

Zadania 1–2 ($k = 1$):

| nr  | $x_I$   | $y_I$   | $z_I$    | $\Delta t$ | $E_{\text{kin}}$ | $E_{\text{pot}}$ | $E_{\text{całk}}$ |
| --- | ------- | ------- | -------- | ---------- | ---------------- | ---------------- | ----------------- |
| 1   | 1.1516  | 12.3033 | 152.6967 | 3.0758     | 483.0327         | 1526.9673        | 2010.0000         |
| 2   | 3.7196  | -5.1916 | 40.7882  | 2.5871     | 1602.1179        | 407.8821         | 2010.0000         |
| 3   | -2.6942 | 0.6630  | 7.6981   | 0.5761     | 1933.0189        | 76.9811          | 2010.0000         |
| 4   | 1.1959  | 0.5497  | 1.7324   | 0.1137     | 1992.6760        | 17.3240          | 2010.0000         |
| 5   | -0.5235 | -0.8590 | 1.0119   | 0.0370     | 1999.8808        | 10.1192          | 2010.0000         |

Energia całkowita jest stała (2010 J) w każdym punkcie zderzenia, więc bez strat energia się zachowuje.

Zadanie 3 ($k = 0{,}8$):

| nr  | $x_I$   | $y_I$   | $z_I$    | $\Delta t$ | $E_{\text{kin}}$ | $E_{\text{pot}}$ | $E_{\text{całk}}$ |
| --- | ------- | ------- | -------- | ---------- | ---------------- | ---------------- | ----------------- |
| 1   | 1.1516  | 12.3033 | 152.6967 | 3.0758     | 483.0327         | 1526.9673        | 2010.0000         |
| 2   | 3.6590  | -4.7787 | 36.2244  | 2.8242     | 1551.1498        | 362.2437         | 1913.3935         |
| 3   | -2.3182 | 0.3989  | 5.5330   | 0.6011     | 1547.8332        | 55.3303          | 1603.1635         |
| 4   | 0.9060  | 0.5192  | 1.0904   | 0.1094     | 1282.6929        | 10.9040          | 1293.5969         |
| 5   | -0.4207 | -0.8360 | 0.8759   | 0.0421     | 1028.2993        | 8.7590           | 1037.0583         |

Przy stratach energia całkowita maleje po każdym odbiciu: 2010 → 1913,39 → 1603,16 → 1293,60 → 1037,06.
