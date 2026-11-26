#set page(paper: "a4", margin: 1.5cm)
#set text(lang: "pl", size: 11pt)
#set heading(numbering: "1.")

#align(center)[
  #text(size: 14pt, weight: "bold")[MiSS - Laboratorium 3] \
  Krzysztof Nasuta, s193328 \
  Filip Dawidowski, s193433
]

= Wyprowadzenie wzorów

*Równanie.* Drgania struny z tłumieniem opisuje równanie falowe

$ (partial^2 y) / (partial t^2) = v^2 (partial^2 y) / (partial x^2) - 2 beta (partial y) / (partial t), quad v = sqrt(T / mu), quad beta = b / (2 mu). $

Dane: $mu = "0,01"$ kg/m, $T = 100$ N, $b = "0,5"$ N·s/m², $L = 1$ m, $M = 100$ węzłów, $N = 2000$ poziomów czasowych, stąd $v = 100$ m/s i $beta = 25$ 1/s. Warunki początkowe i brzegowe:

$
  y(x, 0) = s(x) = -2 x^2 + "0,8" x + "0,92", quad (partial y) / (partial t)(x, 0) = g(x) = sin(2 pi x),
$

$
  (partial y) / (partial x)(0, t) = h = "0,8", quad y(L, t) = r = -"0,28".
$

*Dyskretyzacja.* Siatka: $x_m = (m - 1) Delta x$, $Delta x = L / (M - 1)$, $t_k = (k - 1) Delta t$, $Delta t = (Delta x) / v$ (warunek CFL), $y_m^((k)) = y(x_m, t_k)$. Różnice centralne:

$
  (partial^2 y) / (partial t^2) approx (y_m^((k+1)) - 2 y_m^((k)) + y_m^((k-1))) / (Delta t^2), quad
  (partial y) / (partial t) approx (y_m^((k+1)) - y_m^((k-1))) / (2 Delta t), quad
  (partial^2 y) / (partial x^2) approx (y_(m+1)^((k)) - 2 y_m^((k)) + y_(m-1)^((k))) / (Delta x^2).
$

Wstawiając do równania i oznaczając $p = (v Delta t / Delta x)^2$ ($= 1$), $q = 1 + beta Delta t$, $u = 1 - beta Delta t$, dla węzłów wewnętrznych ($m = 2, dots, M - 1$) i $k >= 2$:

$ y_m^((k+1)) = p / q (y_(m+1)^((k)) - 2 y_m^((k)) + y_(m-1)^((k))) + 2 / q y_m^((k)) - u / q y_m^((k-1)). $

*Pierwszy krok.* Dla $k = 1$ wzór zawiera $y_m^((0))$ (węzeł fikcyjny). Z prędkości początkowej $(y_m^((2)) - y_m^((0))) / (2 Delta t) = g_m$ mamy $y_m^((0)) = y_m^((2)) - 2 Delta t g_m$. Podstawiając, z $q + u = 2$:

$ y_m^((1)) = s_m, quad y_m^((2)) = p / 2 (y_(m+1)^((1)) - 2 y_m^((1)) + y_(m-1)^((1))) + y_m^((1)) + u Delta t g_m. $

*Brzeg prawy* (Dirichlet): $y_M^((k)) = r$.

*Brzeg lewy* (Neumann). Pochodną w $x = 0$ zastępujemy różnicą centralną z węzłem fikcyjnym $y_0$: $(y_2^((k)) - y_0^((k))) / (2 Delta x) = h$, czyli $y_0^((k)) = y_2^((k)) - 2 Delta x h$. Po wstawieniu do wzoru ogólnego dla $m = 1$:

$ y_1^((k+1)) = (2 p) / q (y_2^((k)) - y_1^((k)) - Delta x h) + 2 / q y_1^((k)) - u / q y_1^((k-1)), quad k >= 2, $

a dla pierwszego kroku (jak wyżej, z $y_1^((0))$ wyeliminowanym przez $g_1$):

$ y_1^((2)) = p (y_2^((1)) - y_1^((1)) - Delta x h) + y_1^((1)) + u Delta t g_1. $

*Bez tłumienia* ($beta = 0$) jest $q = u = 1$ i wzory przechodzą w wersję z wykładu.

*Rozwiązanie równowagowe.* W stanie ustalonym $partial^2 y / partial t^2 = 0$ i $partial y / partial t = 0$, więc $y_E'' (x) = 0$, czyli $y_E (x) = c x + d$. Z warunków brzegowych:

$ y_E'(0) = c = "0,8", quad y_E (L) = "0,8" dot.op 1 + d = -"0,28" arrow d = -"1,08", quad y_E (x) = "0,8" x - "1,08". $

Warunek początkowy $s(x)$ jest zgodny z brzegowymi: $s'(0) = "0,8"$, $s(1) = -"0,28"$.

= Wykresy

#figure(image("string_beta_0.png", width: 85%), caption: [Zadanie 1: $y(x, t)$ bez tłumienia ($beta = 0$).])

#figure(image("string_beta_damped.png", width: 85%), caption: [Zadanie 2: $y(x, t)$ z tłumieniem ($beta = 25$).])

#figure(image("equilibrium.png", width: 70%), caption: [Zadanie 3: ostatnia iteracja symulacji z tłumieniem oraz rozwiązanie równowagowe $y_E (x) = "0,8" x - "1,08"$.])

= Wyniki

*Zadanie 1.* Krok czasowy $Delta t = (Delta x) / v approx "1,01" dot.op 10^(-4)$ s spełnia warunek CFL ($p = 1$), więc rozwiązanie jest stabilne. Bez tłumienia struna drga okresowo, a amplituda się nie zmniejsza.

*Zadanie 2.* Przy $beta = 25$ drgania szybko wygasają i po czasie $t approx "0,2"$ s struna jest prawie prosta.

*Zadanie 3.* Ostatnia iteracja ($t = "0,2019"$ s) różni się od $y_E (x)$ co najwyżej o $"0,0126"$ m (dla porównania bez tłumienia różnica to $"1,93"$ m). Symulacja z tłumieniem jest więc zgodna z rozwiązaniem równowagowym; pozostała różnica wynika ze skończonego czasu symulacji (amplituda maleje jak $e^(-beta t) approx "0,007"$).
