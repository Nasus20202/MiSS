#set page(paper: "a4", margin: 1.5cm)
#set text(lang: "pl", size: 11pt)
#set heading(numbering: "1.")

#align(center)[
  #text(size: 14pt, weight: "bold")[MiSS - Laboratorium 3] \
  Krzysztof Nasuta, s193328 \
  Filip Dawidowski, s193433
]

= Dane z zadania (zestaw 5)

$mu = "0,01"$ kg/m, $T = 100$ N, $b = "0,5"$ N·s/m², $L = 1$ m, $M = 100$ węzłów, $N = 2000$ poziomów czasowych.

Warunki początkowe:

$ y(x, 0) = s(x) = x^3 - "1,5" x^2 + "0,5" x + "0,3", quad (partial y) / (partial t)(x, 0) = g(x) = x^3 - "1,5" x^2 + "0,5" x. $

Warunki brzegowe (lewy koniec: Dirichlet, prawy koniec: Neumann):

$ y(0, t) = l = "0,3", quad (partial y) / (partial x)(L, t) = w = "0,5". $

= Wyprowadzenie wzorów

*Równanie falowe z tłumieniem:*

$ (partial^2 y) / (partial t^2) = v^2 (partial^2 y) / (partial x^2) - 2 beta (partial y) / (partial t), quad v = sqrt(T / mu) = 100 " m/s", quad beta = b / (2 mu) = 25 " 1/s". $

*Dyskretyzacja.* $y_(k, m) = y(x_m, t_k)$ (w kodzie `y[k, m]`), $x_m = (m - 1) Delta x$, $t_k = (k - 1) Delta t$, $Delta x = L / (M - 1)$. Z warunku CFL ($Delta t <= Delta x \/ v$) przyjmujemy $Delta t = Delta x \/ v approx "1,01" dot.op 10^(-4)$ s. Pochodne zastępujemy różnicami centralnymi:

$
  (y_(k+1, m) - 2 y_(k, m) + y_(k-1, m)) / (Delta t^2)
  = v^2 (y_(k, m+1) - 2 y_(k, m) + y_(k, m-1)) / (Delta x^2)
  - 2 beta (y_(k+1, m) - y_(k-1, m)) / (2 Delta t).
$

*Węzły wewnętrzne* ($m = 2, dots, M - 1$, $k >= 2$). Wyznaczamy $y_(k+1, m)$ i oznaczamy $p = (v Delta t \/ Delta x)^2 = 1$, $q = 1 + beta Delta t$, $u = 1 - beta Delta t$:

$ y_(k+1, m) = p / q (y_(k, m+1) - 2 y_(k, m) + y_(k, m-1)) + 2 / q y_(k, m) - u / q y_(k-1, m). $

*Pierwszy krok.* $y_(1, m) = s_m$. Wzór ogólny dla $k = 1$ zawiera węzeł fikcyjny $y_(0, m)$, który wyznaczamy z prędkości początkowej:

$ (y_(2, m) - y_(0, m)) / (2 Delta t) = g_m quad "stąd" quad y_(0, m) = y_(2, m) - 2 Delta t g_m. $

Po podstawieniu (z $q + u = 2$):

$ y_(2, m) = p / 2 (y_(1, m+1) - 2 y_(1, m) + y_(1, m-1)) + y_(1, m) + u Delta t g_m. $

*Brzeg lewy* (Dirichlet): $y_(k, 1) = l$.

*Brzeg prawy* (Neumann; jak w wykładzie dla lewego końca, w odbiciu lustrzanym). Z węzłem fikcyjnym $y_(k, M+1)$:

$ (y_(k, M+1) - y_(k, M-1)) / (2 Delta x) = w quad "stąd" quad y_(k, M+1) = y_(k, M-1) + 2 Delta x w. $

Po podstawieniu do wzoru ogólnego i do wzoru na pierwszy krok dla $m = M$:

$ y_(k+1, M) = (2 p) / q (y_(k, M-1) - y_(k, M) + Delta x w) + 2 / q y_(k, M) - u / q y_(k-1, M), quad k >= 2, $

$ y_(2, M) = p (y_(1, M-1) - y_(1, M) + Delta x w) + y_(1, M) + u Delta t g_M. $

*Bez tłumienia* ($beta = 0$) jest $q = u = 1$.

*Rozwiązanie równowagowe.* W stanie ustalonym pochodne po czasie znikają, więc $(partial^2 y_E) / (partial x^2) = 0$, czyli $y_E (x) = c x + d$. Z warunków brzegowych $y_E (0) = d = "0,3"$, a nachylenie na prawym końcu to $c = w = "0,5"$:

$ y_E (x) = "0,5" x + "0,3". $

= Wykresy

#figure(image("string_beta_0.png", width: 85%), caption: [Zadanie 1: $y(x, t)$ bez tłumienia ($beta = 0$).])

#figure(image("string_beta_damped.png", width: 85%), caption: [Zadanie 2: $y(x, t)$ z tłumieniem ($beta = 25$).])

#figure(image("equilibrium.png", width: 70%), caption: [Zadanie 3: ostatnia iteracja symulacji z tłumieniem oraz rozwiązanie równowagowe $y_E (x) = "0,5" x + "0,3"$.])

= Wyniki

*Zadanie 1.* Bez tłumienia struna drga okresowo, a amplituda się nie zmniejsza.

*Zadanie 2.* Przy $beta = 25$ drgania szybko wygasają i po czasie $t approx "0,2"$ s struna jest prawie prosta.

*Zadanie 3.* Ostatnia iteracja ($t = "0,2019"$ s) różni się od $y_E (x)$ co najwyżej o $"0,0030"$ m. Symulacja z tłumieniem jest więc zgodna z rozwiązaniem równowagowym; pozostała różnica wynika ze skończonego czasu symulacji.
