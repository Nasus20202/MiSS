#set page(paper: "a4", margin: 1.5cm)
#set text(lang: "pl", size: 11pt)
#set heading(numbering: "1.")

#align(center)[
  #text(size: 14pt, weight: "bold")[MiSS - Laboratorium 2] \
  Krzysztof Nasuta, s193328 \
  Filip Dawidowski, s193433
]

= Wyprowadzenie wzoru

*Moment zderzenia.* Ciało w chwili $t$ ma położenie $x = x_0 + v_(0x) t$, $y = y_0 + v_(0y) t$, $z = z_0 + v_(0z) t - g/2 t^2$. W chwili zderzenia punkt leży na powierzchni, czyli $z = f(x, y)$:

$ z_0 + v_(0z) t - g/2 t^2 = (x_0 + v_(0x) t)(y_0 + v_(0y) t) + (x_0 + v_(0x) t) + (y_0 + v_(0y) t) $

Mnożąc nawiasy i grupując wyrazy według potęg $t$:

$ z_0 + v_(0z) t - g/2 t^2 = v_(0x) v_(0y) t^2 + (x_0 v_(0y) + y_0 v_(0x) + v_(0x) + v_(0y)) t + (x_0 y_0 + x_0 + y_0) $

Przenosimy wszystko na jedną stronę i mnożymy przez $-1$:

$ (v_(0x) v_(0y) + g/2) t^2 + (x_0 v_(0y) + y_0 v_(0x) + v_(0x) + v_(0y) - v_(0z)) t + (x_0 y_0 + x_0 + y_0 - z_0) = 0 $

Stąd równanie kwadratowe $a t^2 + b t + c = 0$ z

$
  a = v_(0x) v_(0y) + g/2, quad b = x_0 v_(0y) + y_0 v_(0x) + v_(0x) + v_(0y) - v_(0z), quad c = x_0 y_0 + x_0 + y_0 - z_0.
$

Po każdym odbiciu $c = 0$, więc program wybiera największy dodatni pierwiastek.

*Punkt zderzenia.* $x_I = x_0 + v_(0x) t_I$, $y_I = y_0 + v_(0y) t_I$, $z_I = z_0 + v_(0z) t_I - g/2 t_I^2$.

*Odbicie.* Wektor normalny do powierzchni:

$ arrow(n) = (-(y + 1), -(x + 1), 1) / norm(arrow(N)), quad arrow(N) = (-(y + 1), -(x + 1), 1) $

Prędkość po odbiciu, z uwzględnieniem strat $k$:

$ arrow(v)_"po" = sqrt(k) (arrow(v)_"przed" - 2 (arrow(v)_"przed" dot.op arrow(n)) arrow(n)) $

*Energia.* $E_"całk" = E_"pot" + E_"kin" = m g z_I + (m norm(arrow(v))^2) / 2$, liczona z prędkości tuż przed zderzeniem.

= Wykresy

#figure(image("trajectories_k_1.0.png", width: 90%), caption: [Zadanie 1–2: powierzchnia i tory odbić dla $k = 1$.])

#figure(image("two_panel_overview_k_1.0.png", width: 100%), caption: [Zadanie 1–2: widok całej powierzchni (lewo) i przybliżenie na odbicia (prawo), $k = 1$.])

#figure(image("trajectories_k_0.9.png", width: 90%), caption: [Zadanie 3: powierzchnia i tory odbić dla $k = "0,9"$.])

#figure(image("two_panel_overview_k_0.9.png", width: 100%), caption: [Zadanie 3: widok całej powierzchni (lewo) i przybliżenie na odbicia (prawo), $k = "0,9"$.])

= Wyniki

*Zadanie 1–2* ($k = 1$). Energia całkowita jest stała ($"2025,05"$ J) w każdym punkcie zderzenia, więc bez strat energia się zachowuje. Ujemna energia potencjalna w 5. zderzeniu wynika z tego, że powierzchnia schodzi tam poniżej $z = 0$.

#table(
  columns: 8,
  align: right,
  table.header([*nr*], [$x_I$], [$y_I$], [$z_I$], [$Delta t$], [$E_"kin"$], [$E_"pot"$], [$E_"całk"$]),
  [1], [12.0933], [12.1175], [170.7505], [2.4187], [317.5447], [1707.5054], [2025.0500],
  [2], [-8.5347], [-8.4145], [54.8660], [3.0193], [1476.3898], [548.6602], [2025.0500],
  [3], [2.3047], [2.7144], [11.2748], [0.7968], [1912.3022], [112.7478], [2025.0500],
  [4], [-3.6428], [-2.2228], [2.2315], [0.1902], [2002.7347], [22.3153], [2025.0500],
  [5], [-1.1056], [15.2608], [-2.7165], [0.2882], [2052.2148], [-27.1647], [2025.0500],
)

*Zadanie 3* ($k = "0,9"$). Przy stratach energia całkowita maleje po każdym odbiciu: $"2025,05" arrow "1993,30" arrow "1845,59" arrow "1670,41" arrow "1504,92"$.

#table(
  columns: 8,
  align: right,
  table.header([*nr*], [$x_I$], [$y_I$], [$z_I$], [$Delta t$], [$E_"kin"$], [$E_"pot"$], [$E_"całk"$]),
  [1], [12.0933], [12.1175], [170.7505], [2.4187], [317.5447], [1707.5054], [2025.0500],
  [2], [-8.3144], [-8.1952], [51.6284], [3.1486], [1477.0113], [516.2843], [1993.2956],
  [3], [2.0285], [2.4247], [9.3717], [0.8089], [1751.8772], [93.7173], [1845.5945],
  [4], [-3.4073], [-2.0623], [1.5572], [0.1851], [1654.8350], [15.5717], [1670.4067],
  [5], [-1.0908], [18.9589], [-2.8126], [0.3931], [1533.0489], [-28.1257], [1504.9232],
)
