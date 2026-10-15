# Wyprowadzenie równań z kodu

Oznaczenia jak w kodzie: `v0_x`, `v0_y`, `g`, odcinek `[x1, y1, x2, y2]`.

## 1. Składowe prędkości

$$v_{0x} = v_0 \cos\alpha, \qquad v_{0y} = v_0 \sin\alpha$$

## 2. Tor jako funkcja x

Ruch w poziomie jest jednostajny, w pionie działa grawitacja:

$$x = v_{0x}\, t \qquad (1)$$

$$y = v_{0y}\, t - \tfrac12 g t^2 \qquad (2)$$

Z (1): $t = \dfrac{x}{v_{0x}}$. Wstawiam do (2):

$$
y = v_{0y}\,\frac{x}{v_{0x}} - \tfrac12 g \left(\frac{x}{v_{0x}}\right)^2
= \frac{v_{0y}}{v_{0x}}\, x - \frac{g}{2 v_{0x}^2}\, x^2
$$

W kodzie (`t_a`, `t_b`):

$$y = t_a x^2 + t_b x, \qquad t_a = -\frac{g}{2 v_{0x}^2}, \qquad t_b = \frac{v_{0y}}{v_{0x}}$$

## 3. Odcinek pionowy ($x_1 = x_2$)

Nachylenie $\frac{y_2 - y_1}{x_2 - x_1}$ wymagałoby dzielenia przez zero, więc nie używam prostej.
Współrzędna $x = x_1$ jest znana, więc podstawiam ją do toru:

$$y = t_b x_1 + t_a x_1^2$$

Trafienie:

$$\min(y_1, y_2) \le y \le \max(y_1, y_2)$$

## 4. Odcinek niepionowy ($x_1 \ne x_2$)

Prosta przez końce odcinka, $y = l_a x + l_b$ (w kodzie `l_a`, `l_b`):

$$l_a = \frac{y_2 - y_1}{x_2 - x_1}$$

Prosta przechodzi przez $(x_1, y_1)$, więc $y_1 = l_a x_1 + l_b$, czyli:

$$l_b = y_1 - l_a x_1$$

(Odcinek poziomy to $l_a = 0$, osobny przypadek nie jest potrzebny.)

## 5. Przecięcie toru z prostą

W punkcie przecięcia oba $y$ są równe:

$$t_a x^2 + t_b x = l_a x + l_b$$

Przenoszę wszystko na jedną stronę:

$$t_a x^2 + (t_b - l_a)\, x - l_b = 0$$

To równanie kwadratowe $a x^2 + b x + c = 0$, gdzie (w kodzie):

$$a = t_a, \qquad b = t_b - l_a, \qquad c = -l_b$$

Wyróżnik i pierwiastki:

$$D = b^2 - 4ac$$

$$\text{root1} = \frac{-b + \sqrt D}{2a}, \qquad \text{root2} = \frac{-b - \sqrt D}{2a}$$

Dzielenie przez $2a$ jest bezpieczne, bo $a = t_a < 0$ dla każdego $v_{0x} \ne 0$.

## 6. Warunek trafienia w odcinek

Pierwiastki to punkty przecięcia z całą prostą, a odcinek jest jej fragmentem. Trzeba więc sprawdzić zakres:

$$x_{min} = \min(x_1, x_2), \qquad x_{max} = \max(x_1, x_2)$$

$$D \ge 0 \;\wedge\; \big(\, x_{min} \le \text{root1} \le x_{max} \;\vee\; x_{min} \le \text{root2} \le x_{max} \,\big)$$

Dla $D < 0$ nie ma przecięcia. W kodzie (wektory) pierwiastek liczę jako `sqrt(max(D, 0))`,
a trafienie maskuję warunkiem `D >= 0`, żeby nie powstawały liczby zespolone.

## 7. Warunek końcowy

Dla każdej próby:

- `allowed_ok`: tor trafia we **wszystkie** odcinki z `allowed` (iloczyn logiczny, `&`),
- `forbidden_hit`: tor trafia w **którykolwiek** odcinek z `forbidden` (suma logiczna, `|`),
- `result = allowed_ok & ~forbidden_hit`.

## 8. Prawdopodobieństwo (zadanie 3)

$$\text{prob} = \frac{\text{liczba prób z } result = 1}{\text{liczba wszystkich prób}}$$
