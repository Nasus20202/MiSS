#set page(paper: "a4", margin: 1.5cm)
#set text(lang: "pl", size: 11pt)
#set heading(numbering: "1.")

#align(center)[
  #text(size: 14pt, weight: "bold")[MiSS - Laboratorium 1] \
  Krzysztof Nasuta, s193328 \
  Filip Dawidowski, s193433
]

= Wyprowadzenie wzoru

*Rzut ukośny*

$ x = v_x dot t, quad y = v_y dot t - (g t^2)/2 $

$ t = x / v_x $

$ y = v_y / v_x dot x - g / (2 v_x^2) dot x^2 $

*Prosta przez punkty* $(x_1, y_1)$ *i* $(x_2, y_2)$

$ a = (y_2 - y_1)/(x_2 - x_1), quad b = y_1 - a x_1 $

$
  y &= a x + b \
  y &= a x + y_1 - a x_1 \
  y &= (y_2 - y_1)/(x_2 - x_1) x + y_1 - x_1 ((y_2 - y_1)/(x_2 - x_1))
$

*Przecięcie toru z prostą*

$ v_y / v_x dot x - g / (2 v_x^2) x^2 = (y_2 - y_1)/(x_2 - x_1) x + y_1 - x_1 ((y_2 - y_1)/(x_2 - x_1)) $

$ -g / (2 v_x^2) x^2 + (v_y / v_x - (y_2 - y_1)/(x_2 - x_1)) x - y_1 + x_1 ((y_2 - y_1)/(x_2 - x_1)) = 0 $

$
  A &= -g / (2 v_x^2) \
  B &= v_y / v_x - (y_2 - y_1)/(x_2 - x_1) \
  C &= x_1 ((y_2 - y_1)/(x_2 - x_1)) - y_1
$

$ Delta = B^2 - 4 A C $

$ root_1 = (-B + sqrt(Delta))/(2 A), quad root_2 = (-B - sqrt(Delta))/(2 A) $

= Kod

#block(
  width: 100%,
  stroke: 0.5pt + luma(120),
  radius: 3pt,
  inset: 8pt,
  raw(read("lab1.m"), lang: "matlab", block: true),
)

= Wykresy

#figure(image("zad1.png"), caption: [Zadanie 1: zbiór $(alpha, v_0)$ spełniający warunki.])

#figure(image("zad2.png"), caption: [Zadanie 2: obszary i 5 trajektorii.])

= Odpowiedzi

*Zadanie 3.* Prawdopodobieństwo dla pojedynczej próby: $p = k/N$, gdzie $k$ - liczba prób spełniających warunki, $N$ - liczba wszystkich prób. 

Dla $N = 10^5$ otrzymano $p = 0.0264$.

Dokładność wyniku zależy od liczby prób, im większa liczba prób tym dokładniejszy wynik.
