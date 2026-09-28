# Tabulate the number of occurrences per biome

Summarizes the number of **occurrence records** (one row of `x` = one
occurrence) in each biome, for one or more biome schemes. The output is
a long-format table with one row per (scheme, biome) pair.

## Usage

``` r
biomes_tab(x, value = "names")
```

## Arguments

- x:

  A data frame returned by
  [`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md).

- value:

  Character. `"names"` (default) tabulates the `_name` columns from
  [`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md);
  `"ID"` tabulates the `_value` columns.

## Value

A data frame with columns `scheme`, `biome`, and `n` (the number of
occurrence records in that biome on that scheme).

## Details

This function counts occurrences, not species. To count unique species
per biome, deduplicate by species before tabulating (e.g.
`dplyr::distinct(species, biome)` after combining classifications with
the original data).

## Examples

``` r
# Load example occurrence data
data("bombacoideae_occurrences")

# \donttest{
# biomes_classify() downloads and caches the biome raster (~36 MB).

# Tabulate by biome name
classified_names <- biomes_classify(
  x     = bombacoideae_occurrences,
  value = "name"
)
#> no biome file or scheme provided using default biomes
#> Coordinates provided as data.frame, assuming WGS84 as CRS.
#> Classified 17030 record(s) against 31 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
#>   - Biome_Inventory_layer_02 (Buchhorn et al., 2019)
#>   - Biome_Inventory_layer_03 (Beck et al., 2018)
#>   - Biome_Inventory_layer_04 (Hengl et al., 2018)
#>   - Biome_Inventory_layer_05 (Dinerstein et al., 2017)
#>   - Biome_Inventory_layer_06 (Zhang et al., 2017)
#>   - Biome_Inventory_layer_07 (Netzel & Stepinski, 2016a)
#>   - Biome_Inventory_layer_08 (Netzel & Stepinski, 2016b)
#>   - Biome_Inventory_layer_09 (Higgins et al., 2016)
#>   - Biome_Inventory_layer_10 (Pfadenhauer & Klötzli, 2014)
#>   - Biome_Inventory_layer_11 (Zhang & Yan, 2014)
#>   - Biome_Inventory_layer_12 (Metzger et al., 2013)
#>   - Biome_Inventory_layer_13 (Food and Agriculture Organization of the United Nations, 2012)
#>   - Biome_Inventory_layer_14 (Tateishi et al., 2011; Tateishi et al., 2014; Kobayashi et al., 2017)
#>   - Biome_Inventory_layer_15 (Defries et al., 2010)
#>   - Biome_Inventory_layer_16 (Ellis et al., 2010)
#>   - Biome_Inventory_layer_17 (European Space Agency, 2010)
#>   - Biome_Inventory_layer_18 (Friedl et al., 2010)
#>   - Biome_Inventory_layer_19 (The Nature Conservancy, 2009)
#>   - Biome_Inventory_layer_20 (Peel et al., 2007)
#>   - Biome_Inventory_layer_21 (Bartholomé & Belward, 2005)
#>   - Biome_Inventory_layer_22 (Kaplan et al., 2003)
#>   - Biome_Inventory_layer_23 (Olson et al., 2001)
#>   - Biome_Inventory_layer_24 (Loveland et al., 2000)
#>   - Biome_Inventory_layer_25 (Ramankutty & Foley, 1999)
#>   - Biome_Inventory_layer_26 (Leemans, 1990)
#>   - Biome_Inventory_layer_27 (Schultz, 1988, 1995, 2002, 2008, 2016)
#>   - Biome_Inventory_layer_28 (Müller-Hohenstein, 1981)
#>   - Biome_Inventory_layer_29 (Schmithüsen, 1976)
#>   - Biome_Inventory_layer_30 (Whittaker, 1975)
#>   - Biome_Inventory_layer_31 (Walter, 1964, 1968; Walter & Breckle, 1970; Breckle & Rafiqpoor, 2019)
biomes_tab(classified_names, value = "names")
#>                       scheme
#> 1   Biome_Inventory_layer_01
#> 2   Biome_Inventory_layer_01
#> 3   Biome_Inventory_layer_01
#> 4   Biome_Inventory_layer_01
#> 5   Biome_Inventory_layer_01
#> 6   Biome_Inventory_layer_01
#> 7   Biome_Inventory_layer_01
#> 8   Biome_Inventory_layer_01
#> 9   Biome_Inventory_layer_01
#> 10  Biome_Inventory_layer_01
#> 11  Biome_Inventory_layer_01
#> 12  Biome_Inventory_layer_01
#> 13  Biome_Inventory_layer_01
#> 14  Biome_Inventory_layer_01
#> 15  Biome_Inventory_layer_01
#> 16  Biome_Inventory_layer_01
#> 17  Biome_Inventory_layer_02
#> 18  Biome_Inventory_layer_02
#> 19  Biome_Inventory_layer_02
#> 20  Biome_Inventory_layer_02
#> 21  Biome_Inventory_layer_02
#> 22  Biome_Inventory_layer_02
#> 23  Biome_Inventory_layer_02
#> 24  Biome_Inventory_layer_02
#> 25  Biome_Inventory_layer_02
#> 26  Biome_Inventory_layer_02
#> 27  Biome_Inventory_layer_02
#> 28  Biome_Inventory_layer_02
#> 29  Biome_Inventory_layer_02
#> 30  Biome_Inventory_layer_02
#> 31  Biome_Inventory_layer_02
#> 32  Biome_Inventory_layer_02
#> 33  Biome_Inventory_layer_03
#> 34  Biome_Inventory_layer_03
#> 35  Biome_Inventory_layer_03
#> 36  Biome_Inventory_layer_03
#> 37  Biome_Inventory_layer_03
#> 38  Biome_Inventory_layer_03
#> 39  Biome_Inventory_layer_03
#> 40  Biome_Inventory_layer_03
#> 41  Biome_Inventory_layer_03
#> 42  Biome_Inventory_layer_03
#> 43  Biome_Inventory_layer_03
#> 44  Biome_Inventory_layer_03
#> 45  Biome_Inventory_layer_03
#> 46  Biome_Inventory_layer_03
#> 47  Biome_Inventory_layer_03
#> 48  Biome_Inventory_layer_03
#> 49  Biome_Inventory_layer_04
#> 50  Biome_Inventory_layer_04
#> 51  Biome_Inventory_layer_04
#> 52  Biome_Inventory_layer_04
#> 53  Biome_Inventory_layer_04
#> 54  Biome_Inventory_layer_04
#> 55  Biome_Inventory_layer_04
#> 56  Biome_Inventory_layer_04
#> 57  Biome_Inventory_layer_04
#> 58  Biome_Inventory_layer_04
#> 59  Biome_Inventory_layer_04
#> 60  Biome_Inventory_layer_04
#> 61  Biome_Inventory_layer_04
#> 62  Biome_Inventory_layer_04
#> 63  Biome_Inventory_layer_04
#> 64  Biome_Inventory_layer_05
#> 65  Biome_Inventory_layer_05
#> 66  Biome_Inventory_layer_05
#> 67  Biome_Inventory_layer_05
#> 68  Biome_Inventory_layer_05
#> 69  Biome_Inventory_layer_05
#> 70  Biome_Inventory_layer_05
#> 71  Biome_Inventory_layer_05
#> 72  Biome_Inventory_layer_05
#> 73  Biome_Inventory_layer_05
#> 74  Biome_Inventory_layer_05
#> 75  Biome_Inventory_layer_05
#> 76  Biome_Inventory_layer_05
#> 77  Biome_Inventory_layer_05
#> 78  Biome_Inventory_layer_06
#> 79  Biome_Inventory_layer_06
#> 80  Biome_Inventory_layer_06
#> 81  Biome_Inventory_layer_06
#> 82  Biome_Inventory_layer_06
#> 83  Biome_Inventory_layer_06
#> 84  Biome_Inventory_layer_06
#> 85  Biome_Inventory_layer_06
#> 86  Biome_Inventory_layer_06
#> 87  Biome_Inventory_layer_06
#> 88  Biome_Inventory_layer_07
#> 89  Biome_Inventory_layer_07
#> 90  Biome_Inventory_layer_07
#> 91  Biome_Inventory_layer_07
#> 92  Biome_Inventory_layer_07
#> 93  Biome_Inventory_layer_07
#> 94  Biome_Inventory_layer_07
#> 95  Biome_Inventory_layer_07
#> 96  Biome_Inventory_layer_07
#> 97  Biome_Inventory_layer_07
#> 98  Biome_Inventory_layer_07
#> 99  Biome_Inventory_layer_08
#> 100 Biome_Inventory_layer_08
#> 101 Biome_Inventory_layer_08
#> 102 Biome_Inventory_layer_08
#> 103 Biome_Inventory_layer_08
#> 104 Biome_Inventory_layer_08
#> 105 Biome_Inventory_layer_08
#> 106 Biome_Inventory_layer_08
#> 107 Biome_Inventory_layer_08
#> 108 Biome_Inventory_layer_08
#> 109 Biome_Inventory_layer_08
#> 110 Biome_Inventory_layer_08
#> 111 Biome_Inventory_layer_09
#> 112 Biome_Inventory_layer_09
#> 113 Biome_Inventory_layer_09
#> 114 Biome_Inventory_layer_09
#> 115 Biome_Inventory_layer_09
#> 116 Biome_Inventory_layer_09
#> 117 Biome_Inventory_layer_09
#> 118 Biome_Inventory_layer_09
#> 119 Biome_Inventory_layer_09
#> 120 Biome_Inventory_layer_09
#> 121 Biome_Inventory_layer_09
#> 122 Biome_Inventory_layer_09
#> 123 Biome_Inventory_layer_09
#> 124 Biome_Inventory_layer_09
#> 125 Biome_Inventory_layer_09
#> 126 Biome_Inventory_layer_09
#> 127 Biome_Inventory_layer_09
#> 128 Biome_Inventory_layer_10
#> 129 Biome_Inventory_layer_10
#> 130 Biome_Inventory_layer_10
#> 131 Biome_Inventory_layer_10
#> 132 Biome_Inventory_layer_10
#> 133 Biome_Inventory_layer_10
#> 134 Biome_Inventory_layer_10
#> 135 Biome_Inventory_layer_10
#> 136 Biome_Inventory_layer_10
#> 137 Biome_Inventory_layer_10
#> 138 Biome_Inventory_layer_10
#> 139 Biome_Inventory_layer_10
#> 140 Biome_Inventory_layer_10
#> 141 Biome_Inventory_layer_10
#> 142 Biome_Inventory_layer_10
#> 143 Biome_Inventory_layer_10
#> 144 Biome_Inventory_layer_10
#> 145 Biome_Inventory_layer_10
#> 146 Biome_Inventory_layer_10
#> 147 Biome_Inventory_layer_11
#> 148 Biome_Inventory_layer_11
#> 149 Biome_Inventory_layer_11
#> 150 Biome_Inventory_layer_11
#> 151 Biome_Inventory_layer_11
#> 152 Biome_Inventory_layer_11
#> 153 Biome_Inventory_layer_11
#> 154 Biome_Inventory_layer_11
#> 155 Biome_Inventory_layer_11
#> 156 Biome_Inventory_layer_11
#> 157 Biome_Inventory_layer_11
#> 158 Biome_Inventory_layer_12
#> 159 Biome_Inventory_layer_12
#> 160 Biome_Inventory_layer_12
#> 161 Biome_Inventory_layer_12
#> 162 Biome_Inventory_layer_12
#> 163 Biome_Inventory_layer_12
#> 164 Biome_Inventory_layer_12
#> 165 Biome_Inventory_layer_12
#> 166 Biome_Inventory_layer_12
#> 167 Biome_Inventory_layer_12
#> 168 Biome_Inventory_layer_12
#> 169 Biome_Inventory_layer_12
#> 170 Biome_Inventory_layer_12
#> 171 Biome_Inventory_layer_12
#> 172 Biome_Inventory_layer_13
#> 173 Biome_Inventory_layer_13
#> 174 Biome_Inventory_layer_13
#> 175 Biome_Inventory_layer_13
#> 176 Biome_Inventory_layer_13
#> 177 Biome_Inventory_layer_13
#> 178 Biome_Inventory_layer_13
#> 179 Biome_Inventory_layer_13
#> 180 Biome_Inventory_layer_13
#> 181 Biome_Inventory_layer_13
#> 182 Biome_Inventory_layer_13
#> 183 Biome_Inventory_layer_13
#> 184 Biome_Inventory_layer_13
#> 185 Biome_Inventory_layer_13
#> 186 Biome_Inventory_layer_14
#> 187 Biome_Inventory_layer_14
#> 188 Biome_Inventory_layer_14
#> 189 Biome_Inventory_layer_14
#> 190 Biome_Inventory_layer_14
#> 191 Biome_Inventory_layer_14
#> 192 Biome_Inventory_layer_14
#> 193 Biome_Inventory_layer_14
#> 194 Biome_Inventory_layer_14
#> 195 Biome_Inventory_layer_14
#> 196 Biome_Inventory_layer_14
#> 197 Biome_Inventory_layer_14
#> 198 Biome_Inventory_layer_14
#> 199 Biome_Inventory_layer_14
#> 200 Biome_Inventory_layer_14
#> 201 Biome_Inventory_layer_14
#> 202 Biome_Inventory_layer_14
#> 203 Biome_Inventory_layer_14
#> 204 Biome_Inventory_layer_15
#> 205 Biome_Inventory_layer_15
#> 206 Biome_Inventory_layer_15
#> 207 Biome_Inventory_layer_15
#> 208 Biome_Inventory_layer_15
#> 209 Biome_Inventory_layer_15
#> 210 Biome_Inventory_layer_15
#> 211 Biome_Inventory_layer_15
#> 212 Biome_Inventory_layer_15
#> 213 Biome_Inventory_layer_15
#> 214 Biome_Inventory_layer_15
#> 215 Biome_Inventory_layer_15
#> 216 Biome_Inventory_layer_15
#> 217 Biome_Inventory_layer_16
#> 218 Biome_Inventory_layer_16
#> 219 Biome_Inventory_layer_16
#> 220 Biome_Inventory_layer_16
#> 221 Biome_Inventory_layer_16
#> 222 Biome_Inventory_layer_16
#> 223 Biome_Inventory_layer_16
#> 224 Biome_Inventory_layer_16
#> 225 Biome_Inventory_layer_16
#> 226 Biome_Inventory_layer_16
#> 227 Biome_Inventory_layer_16
#> 228 Biome_Inventory_layer_16
#> 229 Biome_Inventory_layer_16
#> 230 Biome_Inventory_layer_16
#> 231 Biome_Inventory_layer_16
#> 232 Biome_Inventory_layer_16
#> 233 Biome_Inventory_layer_16
#> 234 Biome_Inventory_layer_16
#> 235 Biome_Inventory_layer_16
#> 236 Biome_Inventory_layer_16
#> 237 Biome_Inventory_layer_17
#> 238 Biome_Inventory_layer_17
#> 239 Biome_Inventory_layer_17
#> 240 Biome_Inventory_layer_17
#> 241 Biome_Inventory_layer_17
#> 242 Biome_Inventory_layer_17
#> 243 Biome_Inventory_layer_17
#> 244 Biome_Inventory_layer_17
#> 245 Biome_Inventory_layer_17
#> 246 Biome_Inventory_layer_17
#> 247 Biome_Inventory_layer_17
#> 248 Biome_Inventory_layer_17
#> 249 Biome_Inventory_layer_17
#> 250 Biome_Inventory_layer_17
#> 251 Biome_Inventory_layer_17
#> 252 Biome_Inventory_layer_17
#> 253 Biome_Inventory_layer_17
#> 254 Biome_Inventory_layer_17
#> 255 Biome_Inventory_layer_17
#> 256 Biome_Inventory_layer_17
#> 257 Biome_Inventory_layer_17
#> 258 Biome_Inventory_layer_17
#> 259 Biome_Inventory_layer_18
#> 260 Biome_Inventory_layer_18
#> 261 Biome_Inventory_layer_18
#> 262 Biome_Inventory_layer_18
#> 263 Biome_Inventory_layer_18
#> 264 Biome_Inventory_layer_18
#> 265 Biome_Inventory_layer_18
#> 266 Biome_Inventory_layer_18
#> 267 Biome_Inventory_layer_18
#> 268 Biome_Inventory_layer_18
#> 269 Biome_Inventory_layer_18
#> 270 Biome_Inventory_layer_18
#> 271 Biome_Inventory_layer_18
#> 272 Biome_Inventory_layer_18
#> 273 Biome_Inventory_layer_18
#> 274 Biome_Inventory_layer_19
#> 275 Biome_Inventory_layer_19
#> 276 Biome_Inventory_layer_19
#> 277 Biome_Inventory_layer_19
#> 278 Biome_Inventory_layer_19
#> 279 Biome_Inventory_layer_19
#> 280 Biome_Inventory_layer_19
#> 281 Biome_Inventory_layer_19
#> 282 Biome_Inventory_layer_19
#> 283 Biome_Inventory_layer_19
#> 284 Biome_Inventory_layer_19
#> 285 Biome_Inventory_layer_19
#> 286 Biome_Inventory_layer_19
#> 287 Biome_Inventory_layer_19
#> 288 Biome_Inventory_layer_19
#> 289 Biome_Inventory_layer_20
#> 290 Biome_Inventory_layer_20
#> 291 Biome_Inventory_layer_20
#> 292 Biome_Inventory_layer_20
#> 293 Biome_Inventory_layer_20
#> 294 Biome_Inventory_layer_20
#> 295 Biome_Inventory_layer_20
#> 296 Biome_Inventory_layer_20
#> 297 Biome_Inventory_layer_20
#> 298 Biome_Inventory_layer_20
#> 299 Biome_Inventory_layer_20
#> 300 Biome_Inventory_layer_20
#> 301 Biome_Inventory_layer_20
#> 302 Biome_Inventory_layer_20
#> 303 Biome_Inventory_layer_20
#> 304 Biome_Inventory_layer_20
#> 305 Biome_Inventory_layer_21
#> 306 Biome_Inventory_layer_21
#> 307 Biome_Inventory_layer_21
#> 308 Biome_Inventory_layer_21
#> 309 Biome_Inventory_layer_21
#> 310 Biome_Inventory_layer_21
#> 311 Biome_Inventory_layer_21
#> 312 Biome_Inventory_layer_21
#> 313 Biome_Inventory_layer_21
#> 314 Biome_Inventory_layer_21
#> 315 Biome_Inventory_layer_21
#> 316 Biome_Inventory_layer_21
#> 317 Biome_Inventory_layer_21
#> 318 Biome_Inventory_layer_21
#> 319 Biome_Inventory_layer_21
#> 320 Biome_Inventory_layer_21
#> 321 Biome_Inventory_layer_21
#> 322 Biome_Inventory_layer_21
#> 323 Biome_Inventory_layer_21
#> 324 Biome_Inventory_layer_22
#> 325 Biome_Inventory_layer_22
#> 326 Biome_Inventory_layer_22
#> 327 Biome_Inventory_layer_22
#> 328 Biome_Inventory_layer_22
#> 329 Biome_Inventory_layer_22
#> 330 Biome_Inventory_layer_22
#> 331 Biome_Inventory_layer_22
#> 332 Biome_Inventory_layer_22
#> 333 Biome_Inventory_layer_22
#> 334 Biome_Inventory_layer_22
#> 335 Biome_Inventory_layer_22
#> 336 Biome_Inventory_layer_22
#> 337 Biome_Inventory_layer_22
#> 338 Biome_Inventory_layer_22
#> 339 Biome_Inventory_layer_22
#> 340 Biome_Inventory_layer_22
#> 341 Biome_Inventory_layer_22
#> 342 Biome_Inventory_layer_22
#> 343 Biome_Inventory_layer_22
#> 344 Biome_Inventory_layer_22
#> 345 Biome_Inventory_layer_22
#> 346 Biome_Inventory_layer_22
#> 347 Biome_Inventory_layer_23
#> 348 Biome_Inventory_layer_23
#> 349 Biome_Inventory_layer_23
#> 350 Biome_Inventory_layer_23
#> 351 Biome_Inventory_layer_23
#> 352 Biome_Inventory_layer_23
#> 353 Biome_Inventory_layer_23
#> 354 Biome_Inventory_layer_23
#> 355 Biome_Inventory_layer_23
#> 356 Biome_Inventory_layer_23
#> 357 Biome_Inventory_layer_23
#> 358 Biome_Inventory_layer_23
#> 359 Biome_Inventory_layer_23
#> 360 Biome_Inventory_layer_23
#> 361 Biome_Inventory_layer_23
#> 362 Biome_Inventory_layer_24
#> 363 Biome_Inventory_layer_24
#> 364 Biome_Inventory_layer_24
#> 365 Biome_Inventory_layer_24
#> 366 Biome_Inventory_layer_24
#> 367 Biome_Inventory_layer_24
#> 368 Biome_Inventory_layer_24
#> 369 Biome_Inventory_layer_24
#> 370 Biome_Inventory_layer_24
#> 371 Biome_Inventory_layer_24
#> 372 Biome_Inventory_layer_24
#> 373 Biome_Inventory_layer_24
#> 374 Biome_Inventory_layer_24
#> 375 Biome_Inventory_layer_24
#> 376 Biome_Inventory_layer_24
#> 377 Biome_Inventory_layer_24
#> 378 Biome_Inventory_layer_25
#> 379 Biome_Inventory_layer_25
#> 380 Biome_Inventory_layer_25
#> 381 Biome_Inventory_layer_25
#> 382 Biome_Inventory_layer_25
#> 383 Biome_Inventory_layer_25
#> 384 Biome_Inventory_layer_25
#> 385 Biome_Inventory_layer_25
#> 386 Biome_Inventory_layer_25
#> 387 Biome_Inventory_layer_25
#> 388 Biome_Inventory_layer_25
#> 389 Biome_Inventory_layer_25
#> 390 Biome_Inventory_layer_26
#> 391 Biome_Inventory_layer_26
#> 392 Biome_Inventory_layer_26
#> 393 Biome_Inventory_layer_26
#> 394 Biome_Inventory_layer_26
#> 395 Biome_Inventory_layer_26
#> 396 Biome_Inventory_layer_26
#> 397 Biome_Inventory_layer_26
#> 398 Biome_Inventory_layer_26
#> 399 Biome_Inventory_layer_26
#> 400 Biome_Inventory_layer_26
#> 401 Biome_Inventory_layer_26
#> 402 Biome_Inventory_layer_26
#> 403 Biome_Inventory_layer_26
#> 404 Biome_Inventory_layer_26
#> 405 Biome_Inventory_layer_26
#> 406 Biome_Inventory_layer_26
#> 407 Biome_Inventory_layer_26
#> 408 Biome_Inventory_layer_26
#> 409 Biome_Inventory_layer_26
#> 410 Biome_Inventory_layer_26
#> 411 Biome_Inventory_layer_26
#> 412 Biome_Inventory_layer_26
#> 413 Biome_Inventory_layer_26
#> 414 Biome_Inventory_layer_26
#> 415 Biome_Inventory_layer_26
#> 416 Biome_Inventory_layer_26
#> 417 Biome_Inventory_layer_26
#> 418 Biome_Inventory_layer_26
#> 419 Biome_Inventory_layer_26
#> 420 Biome_Inventory_layer_26
#> 421 Biome_Inventory_layer_26
#> 422 Biome_Inventory_layer_26
#> 423 Biome_Inventory_layer_26
#> 424 Biome_Inventory_layer_27
#> 425 Biome_Inventory_layer_27
#> 426 Biome_Inventory_layer_27
#> 427 Biome_Inventory_layer_27
#> 428 Biome_Inventory_layer_27
#> 429 Biome_Inventory_layer_27
#> 430 Biome_Inventory_layer_27
#> 431 Biome_Inventory_layer_27
#> 432 Biome_Inventory_layer_27
#> 433 Biome_Inventory_layer_27
#> 434 Biome_Inventory_layer_27
#> 435 Biome_Inventory_layer_28
#> 436 Biome_Inventory_layer_28
#> 437 Biome_Inventory_layer_28
#> 438 Biome_Inventory_layer_28
#> 439 Biome_Inventory_layer_28
#> 440 Biome_Inventory_layer_28
#> 441 Biome_Inventory_layer_28
#> 442 Biome_Inventory_layer_28
#> 443 Biome_Inventory_layer_28
#> 444 Biome_Inventory_layer_28
#> 445 Biome_Inventory_layer_28
#> 446 Biome_Inventory_layer_28
#> 447 Biome_Inventory_layer_28
#> 448 Biome_Inventory_layer_28
#> 449 Biome_Inventory_layer_29
#> 450 Biome_Inventory_layer_29
#> 451 Biome_Inventory_layer_29
#> 452 Biome_Inventory_layer_29
#> 453 Biome_Inventory_layer_29
#> 454 Biome_Inventory_layer_29
#> 455 Biome_Inventory_layer_29
#> 456 Biome_Inventory_layer_29
#> 457 Biome_Inventory_layer_29
#> 458 Biome_Inventory_layer_29
#> 459 Biome_Inventory_layer_29
#> 460 Biome_Inventory_layer_29
#> 461 Biome_Inventory_layer_29
#> 462 Biome_Inventory_layer_29
#> 463 Biome_Inventory_layer_29
#> 464 Biome_Inventory_layer_29
#> 465 Biome_Inventory_layer_29
#> 466 Biome_Inventory_layer_29
#> 467 Biome_Inventory_layer_29
#> 468 Biome_Inventory_layer_30
#> 469 Biome_Inventory_layer_30
#> 470 Biome_Inventory_layer_30
#> 471 Biome_Inventory_layer_30
#> 472 Biome_Inventory_layer_30
#> 473 Biome_Inventory_layer_30
#> 474 Biome_Inventory_layer_30
#> 475 Biome_Inventory_layer_30
#> 476 Biome_Inventory_layer_30
#> 477 Biome_Inventory_layer_30
#> 478 Biome_Inventory_layer_30
#> 479 Biome_Inventory_layer_31
#> 480 Biome_Inventory_layer_31
#> 481 Biome_Inventory_layer_31
#> 482 Biome_Inventory_layer_31
#> 483 Biome_Inventory_layer_31
#> 484 Biome_Inventory_layer_31
#> 485 Biome_Inventory_layer_31
#> 486 Biome_Inventory_layer_31
#> 487 Biome_Inventory_layer_31
#> 488 Biome_Inventory_layer_31
#> 489 Biome_Inventory_layer_31
#> 490 Biome_Inventory_layer_31
#> 491 Biome_Inventory_layer_31
#> 492 Biome_Inventory_layer_31
#> 493 Biome_Inventory_layer_31
#>                                                                                                   biome
#> 1                                                                    Boreal evergreen needleleaf forest
#> 2                                                                                       Boreal parkland
#> 3                                                                   Boreal summergreen broadleaf forest
#> 4                                                                                                Desert
#> 5                                                                                               Savanna
#> 6                                                                                            Semidesert
#> 7                                                                                                Steppe
#> 8                                                                  Temperate broadleaf evergreen forest
#> 9                                                                 Temperate needleleaf evergreen forest
#> 10                                                                                   Temperate parkland
#> 11                                                                                  Temperate shrubland
#> 12                                                                            Tropical evergreen forest
#> 13                                                                                   Tropical grassland
#> 14                                                                            Tropical raingreen forest
#> 15                                                                              Warm temperate woodland
#> 16                                                                                             no_biome
#> 17                                                                          Bare soil/sparse vegetation
#> 18                                                                  Closed forest (deciduous broadleaf)
#> 19                                                                  Closed forest (evergreen broadleaf)
#> 20                                                                 Closed forest (evergreen needleleaf)
#> 21                                                                                Closed forest (mixed)
#> 22                                                                              Closed forest (unknown)
#> 23                                             Cultivated and managed vegetation/agriculture (cropland)
#> 24                                                                                Herbaceous vegetation
#> 25                                                                                   Herbaceous wetland
#> 26                                                                                         Inland water
#> 27                                                                    Open forest (deciduous broadleaf)
#> 28                                                                   Open forest (evergreen needleleaf)
#> 29                                                                                Open forest (unknown)
#> 30                                                                                               Shrubs
#> 31                                                                                                Urban
#> 32                                                                                             no_biome
#> 33                                                                             Af - Tropical rainforest
#> 34                                                                                Am - Tropical monsoon
#> 35                                                                                Aw - Tropical savanna
#> 36                                                                                BSh - Arid steppe hot
#> 37                                                                               BSk - Arid steppe cold
#> 38                                                                                BWh - Arid desert hot
#> 39                                                                               BWk - Arid desert cold
#> 40                                                             Cfa - Temperate no dry season hot summer
#> 41                                                            Cfb - Temperate no dry season warm summer
#> 42                                                                Csa - Temperate dry summer hot summer
#> 43                                                               Csb - Temperate dry summer warm summer
#> 44                                                                Cwa - Temperate dry winter hot summer
#> 45                                                               Cwb - Temperate dry winter warm summer
#> 46                                                                    Dsb - Cold dry summer warm summer
#> 47                                                                                    ET - Polar tundra
#> 48                                                                                             no_biome
#> 49                                                                     Cold evergreen needleleaf forest
#> 50                                                                     Cool evergreen needleleaf forest
#> 51                                                                                    Cool mixed forest
#> 52                                                                            Cool temperate rainforest
#> 53                                                                                               Desert
#> 54                                                                                               Steppe
#> 55                                                                 Temperate deciduous broadleaf forest
#> 56                                                         Temperate evergreen needleleaf open woodland
#> 57                                                     Tropical deciduous broadleaf forest and woodland
#> 58                                                                  Tropical evergreen broadleaf forest
#> 59                                                                                     Tropical savanna
#> 60                                                             Tropical semi-evergreen broadleaf forest
#> 61                                                            Warm temperate evergreen and mixed forest
#> 62                                                                            Xerophytic woodland scrub
#> 63                                                                                             no_biome
#> 64                                                                          Deserts and xeric shrubland
#> 65                                                                        Flooded grassland and savanna
#> 66                                                                                             Mangrove
#> 67                                                             Mediterranean forest woodland and scrub 
#> 68                                                                      Montane grassland and shrubland
#> 69                                                                                         Rock and ice
#> 70                                                                 Temperate broadleaf and mixed forest
#> 71                                                                             Temperate conifer forest
#> 72                                                            Temperate grassland savanna and shrubland
#> 73                                                           Tropical and subtropical coniferous forest
#> 74                                                        Tropical and subtropical dry broadleaf forest
#> 75                                             Tropical and subtropical grassland savanna and shrubland
#> 76                                                      Tropical and subtropical moist broadleaf forest
#> 77                                                                                             no_biome
#> 78                                                                                          Polar frost
#> 79                                                  Temperate continental climate with deciduous forest
#> 80                                                                                     Temperate desert
#> 81                                                                                  Temperate grassland
#> 82                                                                Tropical Sahel and semiarid grassland
#> 83                                                                                      Tropical desert
#> 84                                                                                      Tropical forest
#> 85                                                                                   Tropical grassland
#> 86                                                                              Tropical monsoon forest
#> 87                                                                                             no_biome
#> 88                                                                                           Cluster 10
#> 89                                                                                           Cluster 11
#> 90                                                                                           Cluster 12
#> 91                                                                                           Cluster 13
#> 92                                                                                            Cluster 3
#> 93                                                                                            Cluster 5
#> 94                                                                                            Cluster 6
#> 95                                                                                            Cluster 7
#> 96                                                                                            Cluster 8
#> 97                                                                                            Cluster 9
#> 98                                                                                             no_biome
#> 99                                                                                           Cluster 10
#> 100                                                                                          Cluster 11
#> 101                                                                                          Cluster 12
#> 102                                                                                          Cluster 13
#> 103                                                                                           Cluster 2
#> 104                                                                                           Cluster 3
#> 105                                                                                           Cluster 5
#> 106                                                                                           Cluster 6
#> 107                                                                                           Cluster 7
#> 108                                                                                           Cluster 8
#> 109                                                                                           Cluster 9
#> 110                                                                                            no_biome
#> 111                                                                                                 SHD
#> 112                                                                                                 SHN
#> 113                                                                                                 SLD
#> 114                                                                                                 SLN
#> 115                                                                                                 SMB
#> 116                                                                                                 SMD
#> 117                                                                                                 SMN
#> 118                                                                                                 THB
#> 119                                                                                                 THD
#> 120                                                                                                 THN
#> 121                                                                                                 TLD
#> 122                                                                                                 TLN
#> 123                                                                                                 TMB
#> 124                                                                                                 TMC
#> 125                                                                                                 TMD
#> 126                                                                                                 TMN
#> 127                                                                                            no_biome
#> 128                                                  Evergreen and seasonal tropical lowland rainforest
#> 129                                                                               Evergreen dry savanna
#> 130                                                                             Evergreen moist savanna
#> 131                                                                 Evergreen nemoral coniferous forest
#> 132                                                                 Evergreen subtropical laurel forest
#> 133                                                                     High mountian steppe semidesert
#> 134                                                                                        Inland water
#> 135                                                                                           Mountains
#> 136                                                                               Raingreen dry savanna
#> 137                                                                             Raingreen moist savanna
#> 138                                                        Semievergreen and raingreen deciduous forest
#> 139                                                                               Subtropical grassland
#> 140                                                                      Subtropical sclerophyll forest
#> 141                                                                         Tropical-subtropical desert
#> 142                                                                     Tropical-subtropical dry forest
#> 143                                                          Tropical-subtropical dwarf bush semidesert
#> 144                                                               Tropical-subtropical grass semidesert
#> 145                                                           Tropical-subtropical succulent semidesert
#> 146                                                                                            no_biome
#> 147                                                                  Frigid deciduous coniferous forest
#> 148                                                 Temperate continental climate with deciduous forest
#> 149                                                                                    Temperate desert
#> 150                                                                                 Temperate grassland
#> 151                                          Temperate maritime climate with evergreen broadleaf forest
#> 152                                                               Tropical Sahel and semiarid grassland
#> 153                                                                                     Tropical desert
#> 154                                                                                     Tropical forest
#> 155                                                                                  Tropical grassland
#> 156                                                                             Tropical monsoon forest
#> 157                                                                                            no_biome
#> 158                                                                                      Cold and mesic
#> 159                                                                              Cool temperate and dry
#> 160                                                                            Cool temperate and moist
#> 161                                                                            Cool temperate and xeric
#> 162                                                                            Extremely cold and mesic
#> 163                                                                              Extremely hot and arid
#> 164                                                                             Extremely hot and moist
#> 165                                                                             Extremely hot and xeric
#> 166                                                                                        Hot and arid
#> 167                                                                                         Hot and dry
#> 168                                                                                       Hot and mesic
#> 169                                                                            Warm temperate and mesic
#> 170                                                                            Warm temperate and xeric
#> 171                                                                                            no_biome
#> 172                                                                                        Inland water
#> 173                                                                                  Subtropical desert
#> 174                                                                              Subtropical dry forest
#> 175                                                                            Subtropical humid forest
#> 176                                                                         Subtropical mountain system
#> 177                                                                                  Subtropical steppe
#> 178                                                                           Temperate mountain system
#> 179                                                                                     Tropical desert
#> 180                                                                                 Tropical dry forest
#> 181                                                                               Tropical moist forest
#> 182                                                                            Tropical mountain system
#> 183                                                                                 Tropical rainforest
#> 184                                                                                  Tropical shrubland
#> 185                                                                                            no_biome
#> 186                                                          Bare soil - consolidated (gravel and rock)
#> 187                                                                   Bare soil - unconsolidated (sand)
#> 188                                                                          Broadleaf deciduous forest
#> 189                                                                          Broadleaf evergreen forest
#> 190                                                                                            Cropland
#> 191                                                                    Cropland/other vegetation mosaic
#> 192                                                                                          Herbaceous
#> 193                                                                   Herbaceous with sparse tree/shrub
#> 194                                                                                            Mangrove
#> 195                                                                                        Mixed forest
#> 196                                                                         Needleleaf evergreen forest
#> 197                                                                                         Paddy field
#> 198                                                                                               Shrub
#> 199                                                                                   Sparse vegetation
#> 200                                                                                           Tree open
#> 201                                                                                               Urban
#> 202                                                                                             Wetland
#> 203                                                                                            no_biome
#> 204                                                                                              Barren
#> 205                                                                           Closed bushland/shrubland
#> 206                                                                                            Cropland
#> 207                                                                          Deciduous broadleaf forest
#> 208                                                                          Evergreen broadleaf forest
#> 209                                                                         Evergreen needleleaf forest
#> 210                                                                                           Grassland
#> 211                                                                                        Mixed forest
#> 212                                                                                      Open shrubland
#> 213                                                                                               Urban
#> 214                                                                          Wooded grassland shrubland
#> 215                                                                                            Woodland
#> 216                                                                                            no_biome
#> 217                                                                  Inhabited treeless and barren land
#> 218                                                                                  Irrigated villages
#> 219                                                                                   Mixed settlements
#> 220                                                                                   Pastoral villages
#> 221                                                                                  Populated cropland
#> 222                                                                                 Populated rangeland
#> 223                                                                                  Populated woodland
#> 224                                                                                    Rainfed villages
#> 225                                                                                     Remote cropland
#> 226                                                                                    Remote rangeland
#> 227                                                                                     Remote woodland
#> 228                                                                      Residential irrigated cropland
#> 229                                                                        Residential rainfed cropland
#> 230                                                                               Residential rangeland
#> 231                                                                                Residential woodland
#> 232                                                                                       Rice villages
#> 233                                                                                               Urban
#> 234                                                                       Wild treeless and barren land
#> 235                                                                                       Wild woodland
#> 236                                                                                            no_biome
#> 237                                                                                           Bare soil
#> 238                                                      Closed (>40%) broadleaf deciduous forest (>5m)
#> 239             Closed (>40%) broadleaf forest or shrubland permanently flooded (saline/brackish water)
#> 240                                                     Closed (>40%) needleleaf evergreen forest (>5m)
#> 241              Closed to open (>15%) (broadleaf or needleleaf evergreen or deciduous) shrubland (<5m)
#> 242                            Closed to open (>15%) broadleaf evergreen or semi-deciduous forest (>5m)
#> 243                     Closed to open (>15%) broadleaf forest regularly flooded (fresh/brackish water)
#> 244 Closed to open (>15%) grassland or woody vegetation regularly flooded (fresh/brackish/saline water)
#> 245                      Closed to open (>15%) herbaceous vegetation (grassland savanna or lichen/moss)
#> 246                                   Closed to open (>15%) mixed broadleaf and needleleaf forest (>5m)
#> 247                           Mosaic cropland (50-70%)/vegetation (grassland/shrubland/forest) (20-50%)
#> 248                                              Mosaic forest or shrubland (50-70%)/grassland (20-50%)
#> 249                                              Mosaic grassland (50-70%)/forest or shrubland (20-50%)
#> 250                           Mosaic vegetation (grassland/shrubland/forest) (50-70%)/cropland (20-50%)
#> 251                                             Open (15-40%) broadleaf deciduous forest/woodland (>5m)
#> 252                                        Open (15-40%) needleleaf deciduous or evergreen forest (>5m)
#> 253                                                    Post-flooding or irrigated cropland (or aquatic)
#> 254                                                                                    Rainfed cropland
#> 255                                                                                        Snow and ice
#> 256                                                                            Sparse (<15%) vegetation
#> 257                                                                                               Urban
#> 258                                                                                            no_biome
#> 259                                                                                              Barren
#> 260                                                                                    Closed shrubland
#> 261                                                                                            Cropland
#> 262                                                                  Cropland/natural vegetation mosaic
#> 263                                                                          Deciduous broadleaf forest
#> 264                                                                          Evergreen broadleaf forest
#> 265                                                                         Evergreen needleleaf forest
#> 266                                                                                           Grassland
#> 267                                                                                        Mixed forest
#> 268                                                                                      Open shrubland
#> 269                                                                                   Permanent wetland
#> 270                                                                                             Savanna
#> 271                                                                                               Urban
#> 272                                                                                       Woody savanna
#> 273                                                                                            no_biome
#> 274                                                                              Desert and xeric shrub
#> 275                                                                       Flooded grassland and savanna
#> 276                                                                                        Inland water
#> 277                                                                                            Mangrove
#> 278                                                             Mediterranean forest woodland and scrub
#> 279                                                                         Montane grassland and shrub
#> 280                                                                                        Rock and ice
#> 281                                                                Temperate broadleaf and mixed forest
#> 282                                                                            Temperate conifer forest
#> 283                                                               Temperate grassland savanna and shrub
#> 284                                                              Tropical subtropical coniferous forest
#> 285                                                           Tropical subtropical dry broadleaf forest
#> 286                                                    Tropical subtropical grassland savanna and shrub
#> 287                                                         Tropical subtropical moist broadleaf forest
#> 288                                                                                            no_biome
#> 289                                                                            Af - Tropical rainforest
#> 290                                                                               Am - Tropical monsoon
#> 291                                                                               Aw - Tropical savanna
#> 292                                                                               BSh - Arid steppe hot
#> 293                                                                              BSk - Arid steppe cold
#> 294                                                                               BWh - Arid desert hot
#> 295                                                                              BWk - Arid desert cold
#> 296                                                            Cfa - Temperate no dry season hot summer
#> 297                                                           Cfb - Temperate no dry season warm summer
#> 298                                                               Csa - Temperate dry summer hot summer
#> 299                                                              Csb - Temperate dry summer warm summer
#> 300                                                               Cwa - Temperate dry winter hot summer
#> 301                                                              Cwb - Temperate dry winter warm summer
#> 302                                                                   Dwb - Cold dry winter warm summer
#> 303                                                                                   ET - Polar tundra
#> 304                                                                                            no_biome
#> 305                                                                                           Bare soil
#> 306                                                                         Cultivated and managed area
#> 307                                                                      Herbaceous cover (closed-open)
#> 308                                                                         Mosaic cropland/shrub/grass
#> 309                                                 Mosaic cropland/tree cover/other natural vegetation
#> 310                                                          Mosaic tree cover/other natural vegetation
#> 311                                                            Regularly flooded shrub/herbaceous cover
#> 312                                                                 Shrub cover (closed-open deciduous)
#> 313                                                                 Shrub cover (closed-open evergreen)
#> 314                                                                       Sparse herbaceous/shrub cover
#> 315                                                             Tree cover (broadleaf deciduous closed)
#> 316                                                               Tree cover (broadleaf deciduous open)
#> 317                                                                    Tree cover (broadleaf evergreen)
#> 318                                                                        Tree cover (mixed leaf type)
#> 319                                                                   Tree cover (needleleaf evergreen)
#> 320                                                          Tree cover (regularly flooded fresh water)
#> 321                                                         Tree cover (regularly flooded saline water)
#> 322                                                                                               Urban
#> 323                                                                                            no_biome
#> 324                                                                                              Barren
#> 325                                                                                   Cold mixed forest
#> 326                                                                                 Cool conifer forest
#> 327                                                                      Deciduous taiga/montane forest
#> 328                                                                                              Desert
#> 329                                                                       Evegreen taiga/montane forest
#> 330                                                                               Open conifer woodland
#> 331                                                                                        Snow and ice
#> 332                                                                                       Steppe tundra
#> 333                                                                         Temperate broadleaf savanna
#> 334                                                                            Temperate conifer forest
#> 335                                                                          Temperate deciduous forest
#> 336                                                                                 Temperate grassland
#> 337                                                                      Temperate sclerophyll woodland
#> 338                                                                      Temperate xerophytic shrubland
#> 339                                                                  Tropical deciduous forest/woodland
#> 340                                                                           Tropical evergreen forest
#> 341                                                                                  Tropical grassland
#> 342                                                                                    Tropical savanna
#> 343                                                                      Tropical semi-deciduous forest
#> 344                                                                       Tropical xerophytic shrubland
#> 345                                                                                   Warm mixed forest
#> 346                                                                                            no_biome
#> 347                                                                         Deserts and xeric shrubland
#> 348                                                                       Flooded grassland and savanna
#> 349                                                                                        Inland water
#> 350                                                                                            Mangrove
#> 351                                                             Mediterranean forest woodland and scrub
#> 352                                                                     Montane grassland and shrubland
#> 353                                                                                        Snow and ice
#> 354                                                                Temperate broadleaf and mixed forest
#> 355                                                                            Temperate conifer forest
#> 356                                                           Temperate grassland savanna and shrubland
#> 357                                                          Tropical and subtropical coniferous forest
#> 358                                                       Tropical and subtropical dry broadleaf forest
#> 359                                            Tropical and subtropical grassland savanna and shrubland
#> 360                                                     Tropical and subtropical moist broadleaf forest
#> 361                                                                                            no_biome
#> 362                                                                                        Bare surface
#> 363                                                                                        Closed shrub
#> 364                                                                             Crop/natural vegetation
#> 365                                                                                            Cropland
#> 366                                                                                 Deciduous broadleaf
#> 367                                                                                 Evergreen broadleaf
#> 368                                                                                Evergreen needleleaf
#> 369                                                                                           Grassland
#> 370                                                                                                 Ice
#> 371                                                                                        Mixed forest
#> 372                                                                                          Open shrub
#> 373                                                                                             Savanna
#> 374                                                                                               Urban
#> 375                                                                                            Wetlands
#> 376                                                                                       Woody savanna
#> 377                                                                                            no_biome
#> 378                                                                                     Dense shrubland
#> 379                                                                                   Desert and barren
#> 380                                                                                Grassland and steppe
#> 381                                                                                      Mixed woodland
#> 382                                                                                      Open shrubland
#> 383                                                                                             Savanna
#> 384                                                                        Temperate deciduous woodland
#> 385                                                                        Temperate evergreen woodland
#> 386                                                                         Tropical deciduous woodland
#> 387                                                                         Tropical evergreen woodland
#> 388                                                                                              Tundra
#> 389                                                                                            no_biome
#> 390                                                                                     Boreal dry bush
#> 391                                                                                 Boreal moist forest
#> 392                                                                                   Boreal rainforest
#> 393                                                                                   Boreal wet forest
#> 394                                                                               Cool temperate desert
#> 395                                                                          Cool temperate desert bush
#> 396                                                                         Cool temperate moist forest
#> 397                                                                           Cool temperate rainforest
#> 398                                                                               Cool temperate steppe
#> 399                                                                           Cool temperate wet forest
#> 400                                                                                        Inland water
#> 401                                                                                        Polar desert
#> 402                                                                                   Polar rain tundra
#> 403                                                                                    Polar wet tundra
#> 404                                                                                  Subtropical desert
#> 405                                                                             Subtropical desert bush
#> 406                                                                              Subtropical dry forest
#> 407                                                                            Subtropical moist forest
#> 408                                                                              Subtropical rainforest
#> 409                                                                            Subtropical thorn steppe
#> 410                                                                              Subtropical wet forest
#> 411                                                                                 Tropical dry forest
#> 412                                                                               Tropical moist forest
#> 413                                                                               Tropical thorn steppe
#> 414                                                                            Tropical very dry forest
#> 415                                                                                 Tropical wet forest
#> 416                                                                               Warm temperate desert
#> 417                                                                          Warm temperate desert bush
#> 418                                                                           Warm temperate dry forest
#> 419                                                                         Warm temperate moist forest
#> 420                                                                           Warm temperate rainforest
#> 421                                                                         Warm temperate thorn steppe
#> 422                                                                           Warm temperate wet forest
#> 423                                                                                            no_biome
#> 424                                                                         Continuous moist subtropics
#> 425                                                                            Continuous moist tropics
#> 426                                                                                         Dry savanna
#> 427                                                                                 Moist mid-latitudes
#> 428                                                                                       Moist savanna
#> 429                                                                                           Mountains
#> 430                                                                        Summer moist xeric shrubland
#> 431                                                                         Tropical-subtropical desert
#> 432                                                                                 Winter moist steppe
#> 433                                                                             Winter moist subtropics
#> 434                                                                                            no_biome
#> 435                                                                               Desert and semidesert
#> 436                                                                 Dry savanna and tropical dry forest
#> 437                                                                                          Dry steppe
#> 438                                                                                      Dry zone oasis
#> 439                                                                                        Inland water
#> 440                                                                                       Moist savanna
#> 441                                                                                     Oceanic islands
#> 442                                                                           Temperate forest and bush
#> 443                                                                     Temperate grassland and pasture
#> 444                                                                                             Tillage
#> 445                                                                                Tropical agriculture
#> 446                                                                           Tropical pasture highland
#> 447                                                                                 Tropical rainforest
#> 448                                                                                            no_biome
#> 449                                                                                          Dry desert
#> 450                                                                                         Dry savanna
#> 451                                                                                        Inland water
#> 452                                                            Laurel forest and subtropical rainforest
#> 453                                                                                       Moist savanna
#> 454                                                                          Mountain coniferous forest
#> 455                                                                           Paramo heath and wet Puna
#> 456                                                                              Sclerophyll vegetation
#> 457                                                                                          Semidesert
#> 458                                                                                Temperate rainforest
#> 459                                                                          Thorn and succulent forest
#> 460                                                                                       Thorn savanna
#> 461                                                                          Thorn shrub and succulents
#> 462                                                                                   Transition steppe
#> 463                                                                                 Tropical dry forest
#> 464                                                                        Tropical mountain rainforest
#> 465                                                                                 Tropical rainforest
#> 466                                                                  Tropical semi-evergreen rainforest
#> 467                                                                                            no_biome
#> 468                                                                               Desert and semidesert
#> 469                                                                                       Mediterranean
#> 470                                                                                    Temperate forest
#> 471                                                                                 Temperate grassland
#> 472                                                                                 Tropical rainforest
#> 473                                                                                    Tropical savanna
#> 474                                                                            Tropical seasonal forest
#> 475                                                                                  Tropical thornwood
#> 476                                                                                   Tundra and alpine
#> 477                                                                                            Woodland
#> 478                                                                                            no_biome
#> 479                                                                                   Desert semidesert
#> 480                             ET Desert semidesert - tropical subtropical seasonal rainforest savanna
#> 481                                                              ET Laurel forest - tropical rainforest
#> 482                                 ET Laurel forest - tropical subtropical seasonal rainforest savanna
#> 483                                                                ET Mediterranean - desert semidesert
#> 484                                                          ET Tropical rainforest - desert semidesert
#> 485                           ET Tropical rainforest - tropical subtropical seasonal rainforest savanna
#> 486                                                                                        Inland water
#> 487                                                                                       Laurel forest
#> 488                                                                                       Mediterranean
#> 489                                                                                 Tropical rainforest
#> 490                                                    Tropical subtropical seasonal rainforest savanna
#> 491                                                                              Winter cold semidesert
#> 492                                                                                  Winter cold steppe
#> 493                                                                                            no_biome
#>        n
#> 1      1
#> 2     81
#> 3      6
#> 4      2
#> 5   1316
#> 6    149
#> 7      3
#> 8    876
#> 9    141
#> 10   186
#> 11   236
#> 12  7405
#> 13   860
#> 14  4367
#> 15   370
#> 16  1031
#> 17    16
#> 18   265
#> 19  5946
#> 20   266
#> 21   250
#> 22   222
#> 23  1716
#> 24  1852
#> 25    99
#> 26    99
#> 27   100
#> 28    30
#> 29  2975
#> 30  1953
#> 31   386
#> 32   855
#> 33  3070
#> 34  2105
#> 35  7201
#> 36  1551
#> 37    72
#> 38   103
#> 39    10
#> 40   454
#> 41   238
#> 42   536
#> 43   255
#> 44   465
#> 45   402
#> 46    17
#> 47    18
#> 48   533
#> 49    13
#> 50     1
#> 51     6
#> 52    43
#> 53    21
#> 54   933
#> 55    10
#> 56     3
#> 57   868
#> 58  2583
#> 59  5879
#> 60   704
#> 61  4189
#> 62   930
#> 63   847
#> 64   451
#> 65    54
#> 66   202
#> 67   549
#> 68    15
#> 69     1
#> 70     2
#> 71   226
#> 72    18
#> 73   443
#> 74  2612
#> 75  4632
#> 76  7283
#> 77   542
#> 78     1
#> 79   120
#> 80    27
#> 81     2
#> 82   539
#> 83   409
#> 84  4562
#> 85  5100
#> 86  5168
#> 87  1102
#> 88  1317
#> 89  2644
#> 90   269
#> 91   126
#> 92    22
#> 93  1986
#> 94    92
#> 95  5452
#> 96   380
#> 97  3220
#> 98  1522
#> 99  1597
#> 100  273
#> 101  847
#> 102 1525
#> 103   43
#> 104    2
#> 105 2089
#> 106  554
#> 107 4527
#> 108  324
#> 109 3727
#> 110 1522
#> 111 1630
#> 112  453
#> 113  202
#> 114   33
#> 115   15
#> 116 1683
#> 117  106
#> 118   42
#> 119 4427
#> 120 6563
#> 121   73
#> 122  139
#> 123    1
#> 124    1
#> 125  731
#> 126  846
#> 127   85
#> 128 5665
#> 129   54
#> 130 1351
#> 131   84
#> 132  307
#> 133   35
#> 134    8
#> 135 1846
#> 136  423
#> 137 2616
#> 138 1210
#> 139   10
#> 140  537
#> 141    1
#> 142 2330
#> 143    5
#> 144    1
#> 145   11
#> 146  536
#> 147 1238
#> 148    2
#> 149  151
#> 150  333
#> 151   90
#> 152 4872
#> 153  116
#> 154 2306
#> 155 5617
#> 156 2240
#> 157   65
#> 158   20
#> 159   84
#> 160   43
#> 161  172
#> 162    2
#> 163   13
#> 164 7127
#> 165 3337
#> 166    5
#> 167 1571
#> 168 3106
#> 169  841
#> 170  213
#> 171  496
#> 172   44
#> 173   93
#> 174   20
#> 175  118
#> 176  972
#> 177   61
#> 178   20
#> 179    3
#> 180 2425
#> 181 4044
#> 182 1427
#> 183 6724
#> 184  580
#> 185  499
#> 186    7
#> 187    2
#> 188 1763
#> 189 4554
#> 190 1183
#> 191 1551
#> 192  431
#> 193  772
#> 194   30
#> 195  281
#> 196  362
#> 197   31
#> 198  948
#> 199   64
#> 200 3603
#> 201  538
#> 202  227
#> 203  683
#> 204   24
#> 205  157
#> 206 1757
#> 207  340
#> 208 3475
#> 209    9
#> 210  518
#> 211  106
#> 212  298
#> 213    1
#> 214 6613
#> 215 2630
#> 216 1102
#> 217  103
#> 218  109
#> 219  340
#> 220  547
#> 221  457
#> 222 1862
#> 223 1587
#> 224 1464
#> 225  154
#> 226  814
#> 227  882
#> 228  145
#> 229 2542
#> 230 2645
#> 231 1463
#> 232   58
#> 233  641
#> 234    3
#> 235 1023
#> 236  191
#> 237   28
#> 238  477
#> 239   85
#> 240  752
#> 241 1621
#> 242 5424
#> 243  137
#> 244  130
#> 245  930
#> 246  143
#> 247 1359
#> 248  502
#> 249  241
#> 250 2629
#> 251  865
#> 252    1
#> 253    2
#> 254  596
#> 255    2
#> 256   47
#> 257  196
#> 258  863
#> 259   12
#> 260   35
#> 261  680
#> 262  909
#> 263  414
#> 264 4579
#> 265   60
#> 266 3894
#> 267    9
#> 268  234
#> 269   44
#> 270 3137
#> 271  603
#> 272 1678
#> 273  742
#> 274 1222
#> 275   53
#> 276   23
#> 277  209
#> 278  595
#> 279   23
#> 280    1
#> 281    2
#> 282  209
#> 283    1
#> 284  460
#> 285 1909
#> 286 4552
#> 287 7258
#> 288  513
#> 289 2460
#> 290 2041
#> 291 7724
#> 292 1377
#> 293   78
#> 294  263
#> 295   11
#> 296  440
#> 297  383
#> 298  499
#> 299  169
#> 300  492
#> 301  508
#> 302    1
#> 303   12
#> 304  572
#> 305   50
#> 306 2560
#> 307 1188
#> 308  720
#> 309 1225
#> 310   50
#> 311  100
#> 312 1608
#> 313   56
#> 314  380
#> 315  618
#> 316 1192
#> 317 4572
#> 318  139
#> 319 1423
#> 320  134
#> 321   35
#> 322  210
#> 323  770
#> 324  112
#> 325    4
#> 326   21
#> 327    1
#> 328  205
#> 329   12
#> 330  316
#> 331    1
#> 332    6
#> 333   17
#> 334  464
#> 335    1
#> 336   74
#> 337  167
#> 338  297
#> 339 2429
#> 340 4058
#> 341   13
#> 342 4429
#> 343 1483
#> 344  825
#> 345  991
#> 346 1104
#> 347 1264
#> 348   53
#> 349   23
#> 350  202
#> 351  611
#> 352   23
#> 353    1
#> 354    2
#> 355  126
#> 356   19
#> 357  454
#> 358 1867
#> 359 4607
#> 360 7265
#> 361  513
#> 362   57
#> 363  641
#> 364 2673
#> 365  754
#> 366  375
#> 367 4797
#> 368   76
#> 369  971
#> 370    1
#> 371  222
#> 372  216
#> 373 2355
#> 374  470
#> 375  265
#> 376 2517
#> 377  640
#> 378 1231
#> 379   11
#> 380  704
#> 381  612
#> 382  173
#> 383 4386
#> 384   42
#> 385  483
#> 386 1354
#> 387 7844
#> 388   43
#> 389  147
#> 390    1
#> 391   74
#> 392    7
#> 393    3
#> 394    3
#> 395   59
#> 396  222
#> 397   17
#> 398  316
#> 399   61
#> 400   47
#> 401   16
#> 402    7
#> 403   11
#> 404    2
#> 405   35
#> 406 2109
#> 407 4727
#> 408  112
#> 409  134
#> 410 1103
#> 411 4008
#> 412 1483
#> 413   11
#> 414  694
#> 415   85
#> 416    3
#> 417   10
#> 418  310
#> 419  708
#> 420    3
#> 421   26
#> 422   42
#> 423  581
#> 424  149
#> 425 4558
#> 426 2465
#> 427   32
#> 428 6385
#> 429 1249
#> 430  963
#> 431   51
#> 432    6
#> 433  636
#> 434  536
#> 435   97
#> 436  985
#> 437  587
#> 438   15
#> 439   36
#> 440 3361
#> 441   18
#> 442  296
#> 443    7
#> 444  240
#> 445 4872
#> 446  263
#> 447 5717
#> 448  536
#> 449    4
#> 450  742
#> 451    5
#> 452  161
#> 453 1940
#> 454  319
#> 455  242
#> 456 1272
#> 457  120
#> 458   16
#> 459  706
#> 460  307
#> 461    9
#> 462   37
#> 463 2433
#> 464 1022
#> 465 4100
#> 466 3059
#> 467  536
#> 468  220
#> 469  485
#> 470 1109
#> 471  386
#> 472 5852
#> 473 1703
#> 474 2064
#> 475 3068
#> 476  462
#> 477 1145
#> 478  536
#> 479  229
#> 480  628
#> 481   82
#> 482  548
#> 483  185
#> 484   13
#> 485 3060
#> 486    5
#> 487   22
#> 488  357
#> 489 5050
#> 490 6224
#> 491   90
#> 492    1
#> 493  536

# Tabulate by raster value
classified_ids <- biomes_classify(
  x     = bombacoideae_occurrences,
  value = "ID"
)
#> no biome file or scheme provided using default biomes
#> Coordinates provided as data.frame, assuming WGS84 as CRS.
#> Classified 17030 record(s) against 31 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
#>   - Biome_Inventory_layer_02 (Buchhorn et al., 2019)
#>   - Biome_Inventory_layer_03 (Beck et al., 2018)
#>   - Biome_Inventory_layer_04 (Hengl et al., 2018)
#>   - Biome_Inventory_layer_05 (Dinerstein et al., 2017)
#>   - Biome_Inventory_layer_06 (Zhang et al., 2017)
#>   - Biome_Inventory_layer_07 (Netzel & Stepinski, 2016a)
#>   - Biome_Inventory_layer_08 (Netzel & Stepinski, 2016b)
#>   - Biome_Inventory_layer_09 (Higgins et al., 2016)
#>   - Biome_Inventory_layer_10 (Pfadenhauer & Klötzli, 2014)
#>   - Biome_Inventory_layer_11 (Zhang & Yan, 2014)
#>   - Biome_Inventory_layer_12 (Metzger et al., 2013)
#>   - Biome_Inventory_layer_13 (Food and Agriculture Organization of the United Nations, 2012)
#>   - Biome_Inventory_layer_14 (Tateishi et al., 2011; Tateishi et al., 2014; Kobayashi et al., 2017)
#>   - Biome_Inventory_layer_15 (Defries et al., 2010)
#>   - Biome_Inventory_layer_16 (Ellis et al., 2010)
#>   - Biome_Inventory_layer_17 (European Space Agency, 2010)
#>   - Biome_Inventory_layer_18 (Friedl et al., 2010)
#>   - Biome_Inventory_layer_19 (The Nature Conservancy, 2009)
#>   - Biome_Inventory_layer_20 (Peel et al., 2007)
#>   - Biome_Inventory_layer_21 (Bartholomé & Belward, 2005)
#>   - Biome_Inventory_layer_22 (Kaplan et al., 2003)
#>   - Biome_Inventory_layer_23 (Olson et al., 2001)
#>   - Biome_Inventory_layer_24 (Loveland et al., 2000)
#>   - Biome_Inventory_layer_25 (Ramankutty & Foley, 1999)
#>   - Biome_Inventory_layer_26 (Leemans, 1990)
#>   - Biome_Inventory_layer_27 (Schultz, 1988, 1995, 2002, 2008, 2016)
#>   - Biome_Inventory_layer_28 (Müller-Hohenstein, 1981)
#>   - Biome_Inventory_layer_29 (Schmithüsen, 1976)
#>   - Biome_Inventory_layer_30 (Whittaker, 1975)
#>   - Biome_Inventory_layer_31 (Walter, 1964, 1968; Walter & Breckle, 1970; Breckle & Rafiqpoor, 2019)
biomes_tab(classified_ids, value = "ID")
#>                       scheme biome    n
#> 1   Biome_Inventory_layer_01     1 7405
#> 2   Biome_Inventory_layer_01     2 4367
#> 3   Biome_Inventory_layer_01     3 1316
#> 4   Biome_Inventory_layer_01     4  860
#> 5   Biome_Inventory_layer_01     5  370
#> 6   Biome_Inventory_layer_01     6    2
#> 7   Biome_Inventory_layer_01     7  876
#> 8   Biome_Inventory_layer_01     8  149
#> 9   Biome_Inventory_layer_01     9  236
#> 10  Biome_Inventory_layer_01    10  141
#> 11  Biome_Inventory_layer_01    11    3
#> 12  Biome_Inventory_layer_01    12  186
#> 13  Biome_Inventory_layer_01    15   81
#> 14  Biome_Inventory_layer_01    17    6
#> 15  Biome_Inventory_layer_01    18    1
#> 16  Biome_Inventory_layer_02     1 5946
#> 17  Biome_Inventory_layer_02     2  100
#> 18  Biome_Inventory_layer_02     3 2975
#> 19  Biome_Inventory_layer_02     4 1953
#> 20  Biome_Inventory_layer_02     5   16
#> 21  Biome_Inventory_layer_02     6 1716
#> 22  Biome_Inventory_layer_02     7  265
#> 23  Biome_Inventory_layer_02     8  222
#> 24  Biome_Inventory_layer_02    10 1852
#> 25  Biome_Inventory_layer_02    11   30
#> 26  Biome_Inventory_layer_02    12  250
#> 27  Biome_Inventory_layer_02    13  266
#> 28  Biome_Inventory_layer_02    14   99
#> 29  Biome_Inventory_layer_02    95   99
#> 30  Biome_Inventory_layer_02    98  386
#> 31  Biome_Inventory_layer_03     1 3070
#> 32  Biome_Inventory_layer_03     2 2105
#> 33  Biome_Inventory_layer_03     3 7201
#> 34  Biome_Inventory_layer_03     5 1551
#> 35  Biome_Inventory_layer_03     6  402
#> 36  Biome_Inventory_layer_03     7  465
#> 37  Biome_Inventory_layer_03     8  103
#> 38  Biome_Inventory_layer_03     9  454
#> 39  Biome_Inventory_layer_03    10  255
#> 40  Biome_Inventory_layer_03    13  238
#> 41  Biome_Inventory_layer_03    14  536
#> 42  Biome_Inventory_layer_03    15   10
#> 43  Biome_Inventory_layer_03    16   17
#> 44  Biome_Inventory_layer_03    17   72
#> 45  Biome_Inventory_layer_03    24   18
#> 46  Biome_Inventory_layer_04     1 2583
#> 47  Biome_Inventory_layer_04     2  704
#> 48  Biome_Inventory_layer_04     3 5879
#> 49  Biome_Inventory_layer_04     4  868
#> 50  Biome_Inventory_layer_04     5  930
#> 51  Biome_Inventory_layer_04     6 4189
#> 52  Biome_Inventory_layer_04     7  933
#> 53  Biome_Inventory_layer_04     9   21
#> 54  Biome_Inventory_layer_04    10    3
#> 55  Biome_Inventory_layer_04    11   10
#> 56  Biome_Inventory_layer_04    12   43
#> 57  Biome_Inventory_layer_04    13    6
#> 58  Biome_Inventory_layer_04    15   13
#> 59  Biome_Inventory_layer_04    16    1
#> 60  Biome_Inventory_layer_05     1 7283
#> 61  Biome_Inventory_layer_05     2  202
#> 62  Biome_Inventory_layer_05     3 4632
#> 63  Biome_Inventory_layer_05     4 2612
#> 64  Biome_Inventory_layer_05     5   54
#> 65  Biome_Inventory_layer_05     6  443
#> 66  Biome_Inventory_layer_05     7  451
#> 67  Biome_Inventory_layer_05     8   15
#> 68  Biome_Inventory_layer_05     9  549
#> 69  Biome_Inventory_layer_05    10   18
#> 70  Biome_Inventory_layer_05    11    2
#> 71  Biome_Inventory_layer_05    12  226
#> 72  Biome_Inventory_layer_05    15    1
#> 73  Biome_Inventory_layer_06     1 4562
#> 74  Biome_Inventory_layer_06     2 5168
#> 75  Biome_Inventory_layer_06     3 5100
#> 76  Biome_Inventory_layer_06     4  539
#> 77  Biome_Inventory_layer_06     5   27
#> 78  Biome_Inventory_layer_06     6  409
#> 79  Biome_Inventory_layer_06     7    2
#> 80  Biome_Inventory_layer_06     8  120
#> 81  Biome_Inventory_layer_06    14    1
#> 82  Biome_Inventory_layer_07     1 1986
#> 83  Biome_Inventory_layer_07     2 3220
#> 84  Biome_Inventory_layer_07     3 5452
#> 85  Biome_Inventory_layer_07     4 2644
#> 86  Biome_Inventory_layer_07     5 1317
#> 87  Biome_Inventory_layer_07     6  269
#> 88  Biome_Inventory_layer_07     7  126
#> 89  Biome_Inventory_layer_07     8   92
#> 90  Biome_Inventory_layer_07     9  380
#> 91  Biome_Inventory_layer_07    11   22
#> 92  Biome_Inventory_layer_08     1 2089
#> 93  Biome_Inventory_layer_08     2 4527
#> 94  Biome_Inventory_layer_08     3 3727
#> 95  Biome_Inventory_layer_08     4 1597
#> 96  Biome_Inventory_layer_08     5 1525
#> 97  Biome_Inventory_layer_08     6  273
#> 98  Biome_Inventory_layer_08     7  847
#> 99  Biome_Inventory_layer_08     8  554
#> 100 Biome_Inventory_layer_08     9  324
#> 101 Biome_Inventory_layer_08    11    2
#> 102 Biome_Inventory_layer_08    12   43
#> 103 Biome_Inventory_layer_09     1 6563
#> 104 Biome_Inventory_layer_09     2 4427
#> 105 Biome_Inventory_layer_09     3 1630
#> 106 Biome_Inventory_layer_09     4  453
#> 107 Biome_Inventory_layer_09     5 1683
#> 108 Biome_Inventory_layer_09     6  731
#> 109 Biome_Inventory_layer_09     7  202
#> 110 Biome_Inventory_layer_09     8   33
#> 111 Biome_Inventory_layer_09     9   42
#> 112 Biome_Inventory_layer_09    10   73
#> 113 Biome_Inventory_layer_09    12  139
#> 114 Biome_Inventory_layer_09    13  106
#> 115 Biome_Inventory_layer_09    14  846
#> 116 Biome_Inventory_layer_09    17   15
#> 117 Biome_Inventory_layer_09    18    1
#> 118 Biome_Inventory_layer_09    21    1
#> 119 Biome_Inventory_layer_10     1 5665
#> 120 Biome_Inventory_layer_10     2 2616
#> 121 Biome_Inventory_layer_10     3 1351
#> 122 Biome_Inventory_layer_10     4  423
#> 123 Biome_Inventory_layer_10     5 1210
#> 124 Biome_Inventory_layer_10     6 2330
#> 125 Biome_Inventory_layer_10     7   54
#> 126 Biome_Inventory_layer_10     8    5
#> 127 Biome_Inventory_layer_10     9    1
#> 128 Biome_Inventory_layer_10    10    1
#> 129 Biome_Inventory_layer_10    11  307
#> 130 Biome_Inventory_layer_10    12   11
#> 131 Biome_Inventory_layer_10    13   35
#> 132 Biome_Inventory_layer_10    14   10
#> 133 Biome_Inventory_layer_10    15  537
#> 134 Biome_Inventory_layer_10    24   84
#> 135 Biome_Inventory_layer_10    95    8
#> 136 Biome_Inventory_layer_10    97 1846
#> 137 Biome_Inventory_layer_11     1 2306
#> 138 Biome_Inventory_layer_11     2 2240
#> 139 Biome_Inventory_layer_11     3 5617
#> 140 Biome_Inventory_layer_11     4 4872
#> 141 Biome_Inventory_layer_11     5  116
#> 142 Biome_Inventory_layer_11     6  333
#> 143 Biome_Inventory_layer_11     7 1238
#> 144 Biome_Inventory_layer_11     8  151
#> 145 Biome_Inventory_layer_11     9   90
#> 146 Biome_Inventory_layer_11    10    2
#> 147 Biome_Inventory_layer_12     1 7127
#> 148 Biome_Inventory_layer_12     2 3106
#> 149 Biome_Inventory_layer_12     3 3337
#> 150 Biome_Inventory_layer_12     4   13
#> 151 Biome_Inventory_layer_12     5 1571
#> 152 Biome_Inventory_layer_12     6    5
#> 153 Biome_Inventory_layer_12     7  213
#> 154 Biome_Inventory_layer_12     8  841
#> 155 Biome_Inventory_layer_12     9   43
#> 156 Biome_Inventory_layer_12    10  172
#> 157 Biome_Inventory_layer_12    11   84
#> 158 Biome_Inventory_layer_12    12   20
#> 159 Biome_Inventory_layer_12    14    2
#> 160 Biome_Inventory_layer_13     1 6724
#> 161 Biome_Inventory_layer_13     2 4044
#> 162 Biome_Inventory_layer_13     3 1427
#> 163 Biome_Inventory_layer_13     4  580
#> 164 Biome_Inventory_layer_13     5 2425
#> 165 Biome_Inventory_layer_13     6    3
#> 166 Biome_Inventory_layer_13     7   93
#> 167 Biome_Inventory_layer_13     8  118
#> 168 Biome_Inventory_layer_13     9  972
#> 169 Biome_Inventory_layer_13    10   61
#> 170 Biome_Inventory_layer_13    11   20
#> 171 Biome_Inventory_layer_13    12   20
#> 172 Biome_Inventory_layer_13    95   44
#> 173 Biome_Inventory_layer_14     1   30
#> 174 Biome_Inventory_layer_14     2 4554
#> 175 Biome_Inventory_layer_14     3  772
#> 176 Biome_Inventory_layer_14     4    2
#> 177 Biome_Inventory_layer_14     5   31
#> 178 Biome_Inventory_layer_14     6 1551
#> 179 Biome_Inventory_layer_14     7  948
#> 180 Biome_Inventory_layer_14     8 1763
#> 181 Biome_Inventory_layer_14     9    7
#> 182 Biome_Inventory_layer_14    10 3603
#> 183 Biome_Inventory_layer_14    11  227
#> 184 Biome_Inventory_layer_14    12   64
#> 185 Biome_Inventory_layer_14    13 1183
#> 186 Biome_Inventory_layer_14    14  431
#> 187 Biome_Inventory_layer_14    15  362
#> 188 Biome_Inventory_layer_14    16  281
#> 189 Biome_Inventory_layer_14    98  538
#> 190 Biome_Inventory_layer_15     1 3475
#> 191 Biome_Inventory_layer_15     2 6613
#> 192 Biome_Inventory_layer_15     3 2630
#> 193 Biome_Inventory_layer_15     4  340
#> 194 Biome_Inventory_layer_15     5  518
#> 195 Biome_Inventory_layer_15     6 1757
#> 196 Biome_Inventory_layer_15     7  298
#> 197 Biome_Inventory_layer_15     8  157
#> 198 Biome_Inventory_layer_15     9   24
#> 199 Biome_Inventory_layer_15    10  106
#> 200 Biome_Inventory_layer_15    11    9
#> 201 Biome_Inventory_layer_15    98    1
#> 202 Biome_Inventory_layer_16     1 2645
#> 203 Biome_Inventory_layer_16     2  547
#> 204 Biome_Inventory_layer_16     3 1463
#> 205 Biome_Inventory_layer_16     4   58
#> 206 Biome_Inventory_layer_16     5 1862
#> 207 Biome_Inventory_layer_16     6  882
#> 208 Biome_Inventory_layer_16     7 1587
#> 209 Biome_Inventory_layer_16     8 1464
#> 210 Biome_Inventory_layer_16     9  340
#> 211 Biome_Inventory_layer_16    10  103
#> 212 Biome_Inventory_layer_16    11  814
#> 213 Biome_Inventory_layer_16    12  109
#> 214 Biome_Inventory_layer_16    13 2542
#> 215 Biome_Inventory_layer_16    14  145
#> 216 Biome_Inventory_layer_16    15  457
#> 217 Biome_Inventory_layer_16    16  154
#> 218 Biome_Inventory_layer_16    17    3
#> 219 Biome_Inventory_layer_16    18 1023
#> 220 Biome_Inventory_layer_16    98  641
#> 221 Biome_Inventory_layer_17     1  137
#> 222 Biome_Inventory_layer_17     2 5424
#> 223 Biome_Inventory_layer_17     3  865
#> 224 Biome_Inventory_layer_17     4   85
#> 225 Biome_Inventory_layer_17     5 1621
#> 226 Biome_Inventory_layer_17     6 2629
#> 227 Biome_Inventory_layer_17     7 1359
#> 228 Biome_Inventory_layer_17     8    2
#> 229 Biome_Inventory_layer_17     9  930
#> 230 Biome_Inventory_layer_17    10   28
#> 231 Biome_Inventory_layer_17    11  596
#> 232 Biome_Inventory_layer_17    12  502
#> 233 Biome_Inventory_layer_17    13  477
#> 234 Biome_Inventory_layer_17    14  752
#> 235 Biome_Inventory_layer_17    15  241
#> 236 Biome_Inventory_layer_17    16  130
#> 237 Biome_Inventory_layer_17    17   47
#> 238 Biome_Inventory_layer_17    18  143
#> 239 Biome_Inventory_layer_17    19    1
#> 240 Biome_Inventory_layer_17    20    2
#> 241 Biome_Inventory_layer_17    98  196
#> 242 Biome_Inventory_layer_18     1 4579
#> 243 Biome_Inventory_layer_18     2  909
#> 244 Biome_Inventory_layer_18     3   35
#> 245 Biome_Inventory_layer_18     4   12
#> 246 Biome_Inventory_layer_18     5 3137
#> 247 Biome_Inventory_layer_18     6 3894
#> 248 Biome_Inventory_layer_18     7  680
#> 249 Biome_Inventory_layer_18     8  414
#> 250 Biome_Inventory_layer_18     9 1678
#> 251 Biome_Inventory_layer_18    10  234
#> 252 Biome_Inventory_layer_18    11   44
#> 253 Biome_Inventory_layer_18    12    9
#> 254 Biome_Inventory_layer_18    13   60
#> 255 Biome_Inventory_layer_18    98  603
#> 256 Biome_Inventory_layer_19     1 7258
#> 257 Biome_Inventory_layer_19     2  209
#> 258 Biome_Inventory_layer_19     3 4552
#> 259 Biome_Inventory_layer_19     4 1909
#> 260 Biome_Inventory_layer_19     5  460
#> 261 Biome_Inventory_layer_19     6   53
#> 262 Biome_Inventory_layer_19     7 1222
#> 263 Biome_Inventory_layer_19     8   23
#> 264 Biome_Inventory_layer_19     9  595
#> 265 Biome_Inventory_layer_19    10    2
#> 266 Biome_Inventory_layer_19    11    1
#> 267 Biome_Inventory_layer_19    12  209
#> 268 Biome_Inventory_layer_19    15    1
#> 269 Biome_Inventory_layer_19    95   23
#> 270 Biome_Inventory_layer_20     1 2460
#> 271 Biome_Inventory_layer_20     2 2041
#> 272 Biome_Inventory_layer_20     3 7724
#> 273 Biome_Inventory_layer_20     5 1377
#> 274 Biome_Inventory_layer_20     6  508
#> 275 Biome_Inventory_layer_20     7  492
#> 276 Biome_Inventory_layer_20     8  263
#> 277 Biome_Inventory_layer_20     9  440
#> 278 Biome_Inventory_layer_20    10  169
#> 279 Biome_Inventory_layer_20    11  499
#> 280 Biome_Inventory_layer_20    13   11
#> 281 Biome_Inventory_layer_20    14  383
#> 282 Biome_Inventory_layer_20    15   78
#> 283 Biome_Inventory_layer_20    18    1
#> 284 Biome_Inventory_layer_20    30   12
#> 285 Biome_Inventory_layer_21     1  134
#> 286 Biome_Inventory_layer_21     2 4572
#> 287 Biome_Inventory_layer_21     3   35
#> 288 Biome_Inventory_layer_21     4 1192
#> 289 Biome_Inventory_layer_21     5 1225
#> 290 Biome_Inventory_layer_21     6  720
#> 291 Biome_Inventory_layer_21     7   50
#> 292 Biome_Inventory_layer_21     8 1188
#> 293 Biome_Inventory_layer_21     9 1608
#> 294 Biome_Inventory_layer_21    10 2560
#> 295 Biome_Inventory_layer_21    11  618
#> 296 Biome_Inventory_layer_21    12   56
#> 297 Biome_Inventory_layer_21    13  380
#> 298 Biome_Inventory_layer_21    14   50
#> 299 Biome_Inventory_layer_21    15  100
#> 300 Biome_Inventory_layer_21    16 1423
#> 301 Biome_Inventory_layer_21    17  139
#> 302 Biome_Inventory_layer_21    98  210
#> 303 Biome_Inventory_layer_22     1 4058
#> 304 Biome_Inventory_layer_22     2 1483
#> 305 Biome_Inventory_layer_22     3 4429
#> 306 Biome_Inventory_layer_22     4 2429
#> 307 Biome_Inventory_layer_22     5  825
#> 308 Biome_Inventory_layer_22     6   13
#> 309 Biome_Inventory_layer_22     7  112
#> 310 Biome_Inventory_layer_22     8  205
#> 311 Biome_Inventory_layer_22     9  991
#> 312 Biome_Inventory_layer_22    10  464
#> 313 Biome_Inventory_layer_22    11  167
#> 314 Biome_Inventory_layer_22    12  316
#> 315 Biome_Inventory_layer_22    13  297
#> 316 Biome_Inventory_layer_22    14    6
#> 317 Biome_Inventory_layer_22    15   17
#> 318 Biome_Inventory_layer_22    16    1
#> 319 Biome_Inventory_layer_22    17   74
#> 320 Biome_Inventory_layer_22    18    4
#> 321 Biome_Inventory_layer_22    20   21
#> 322 Biome_Inventory_layer_22    21   12
#> 323 Biome_Inventory_layer_22    22    1
#> 324 Biome_Inventory_layer_22    26    1
#> 325 Biome_Inventory_layer_23     1 7265
#> 326 Biome_Inventory_layer_23     2  202
#> 327 Biome_Inventory_layer_23     3 4607
#> 328 Biome_Inventory_layer_23     4 1867
#> 329 Biome_Inventory_layer_23     5  454
#> 330 Biome_Inventory_layer_23     6   53
#> 331 Biome_Inventory_layer_23     7 1264
#> 332 Biome_Inventory_layer_23     8   23
#> 333 Biome_Inventory_layer_23     9  611
#> 334 Biome_Inventory_layer_23    10    2
#> 335 Biome_Inventory_layer_23    11  126
#> 336 Biome_Inventory_layer_23    12   19
#> 337 Biome_Inventory_layer_23    15    1
#> 338 Biome_Inventory_layer_23    95   23
#> 339 Biome_Inventory_layer_24     1 4797
#> 340 Biome_Inventory_layer_24     2 2355
#> 341 Biome_Inventory_layer_24     3 2673
#> 342 Biome_Inventory_layer_24     4   57
#> 343 Biome_Inventory_layer_24     5 2517
#> 344 Biome_Inventory_layer_24     6  375
#> 345 Biome_Inventory_layer_24     7  265
#> 346 Biome_Inventory_layer_24     8  641
#> 347 Biome_Inventory_layer_24     9  971
#> 348 Biome_Inventory_layer_24    10  754
#> 349 Biome_Inventory_layer_24    11  216
#> 350 Biome_Inventory_layer_24    12  222
#> 351 Biome_Inventory_layer_24    13   76
#> 352 Biome_Inventory_layer_24    15    1
#> 353 Biome_Inventory_layer_24    98  470
#> 354 Biome_Inventory_layer_25     1 7844
#> 355 Biome_Inventory_layer_25     2 1354
#> 356 Biome_Inventory_layer_25     3 4386
#> 357 Biome_Inventory_layer_25     4 1231
#> 358 Biome_Inventory_layer_25     5   11
#> 359 Biome_Inventory_layer_25     6  173
#> 360 Biome_Inventory_layer_25     7  704
#> 361 Biome_Inventory_layer_25     8  483
#> 362 Biome_Inventory_layer_25     9   42
#> 363 Biome_Inventory_layer_25    10  612
#> 364 Biome_Inventory_layer_25    11   43
#> 365 Biome_Inventory_layer_26     1 1483
#> 366 Biome_Inventory_layer_26     2 1103
#> 367 Biome_Inventory_layer_26     3    3
#> 368 Biome_Inventory_layer_26     4   85
#> 369 Biome_Inventory_layer_26     5  112
#> 370 Biome_Inventory_layer_26     6 4008
#> 371 Biome_Inventory_layer_26     7 4727
#> 372 Biome_Inventory_layer_26     8  694
#> 373 Biome_Inventory_layer_26     9   11
#> 374 Biome_Inventory_layer_26    10 2109
#> 375 Biome_Inventory_layer_26    12   42
#> 376 Biome_Inventory_layer_26    14  134
#> 377 Biome_Inventory_layer_26    15    2
#> 378 Biome_Inventory_layer_26    16   35
#> 379 Biome_Inventory_layer_26    17  708
#> 380 Biome_Inventory_layer_26    18    3
#> 381 Biome_Inventory_layer_26    19  310
#> 382 Biome_Inventory_layer_26    20   17
#> 383 Biome_Inventory_layer_26    21   26
#> 384 Biome_Inventory_layer_26    22   10
#> 385 Biome_Inventory_layer_26    23   61
#> 386 Biome_Inventory_layer_26    24    3
#> 387 Biome_Inventory_layer_26    25   59
#> 388 Biome_Inventory_layer_26    26  316
#> 389 Biome_Inventory_layer_26    27    7
#> 390 Biome_Inventory_layer_26    28  222
#> 391 Biome_Inventory_layer_26    30    1
#> 392 Biome_Inventory_layer_26    31    7
#> 393 Biome_Inventory_layer_26    32    3
#> 394 Biome_Inventory_layer_26    33   74
#> 395 Biome_Inventory_layer_26    34   16
#> 396 Biome_Inventory_layer_26    36   11
#> 397 Biome_Inventory_layer_26    95   47
#> 398 Biome_Inventory_layer_27     1 4558
#> 399 Biome_Inventory_layer_27     2 6385
#> 400 Biome_Inventory_layer_27     3 2465
#> 401 Biome_Inventory_layer_27     4  963
#> 402 Biome_Inventory_layer_27     5   51
#> 403 Biome_Inventory_layer_27     6  149
#> 404 Biome_Inventory_layer_27     7    6
#> 405 Biome_Inventory_layer_27     8  636
#> 406 Biome_Inventory_layer_27    11   32
#> 407 Biome_Inventory_layer_27    97 1249
#> 408 Biome_Inventory_layer_28     1 5717
#> 409 Biome_Inventory_layer_28     2  263
#> 410 Biome_Inventory_layer_28     3 3361
#> 411 Biome_Inventory_layer_28     4  985
#> 412 Biome_Inventory_layer_28     5 4872
#> 413 Biome_Inventory_layer_28     6   97
#> 414 Biome_Inventory_layer_28     7   15
#> 415 Biome_Inventory_layer_28     8  587
#> 416 Biome_Inventory_layer_28     9  240
#> 417 Biome_Inventory_layer_28    10    7
#> 418 Biome_Inventory_layer_28    11  296
#> 419 Biome_Inventory_layer_28    95   36
#> 420 Biome_Inventory_layer_28    96   18
#> 421 Biome_Inventory_layer_29     1 4100
#> 422 Biome_Inventory_layer_29     2  242
#> 423 Biome_Inventory_layer_29     3 1940
#> 424 Biome_Inventory_layer_29     4 1022
#> 425 Biome_Inventory_layer_29     5 3059
#> 426 Biome_Inventory_layer_29     6  742
#> 427 Biome_Inventory_layer_29     7  706
#> 428 Biome_Inventory_layer_29     8  307
#> 429 Biome_Inventory_layer_29     9 2433
#> 430 Biome_Inventory_layer_29    10    4
#> 431 Biome_Inventory_layer_29    11  161
#> 432 Biome_Inventory_layer_29    12  120
#> 433 Biome_Inventory_layer_29    13    9
#> 434 Biome_Inventory_layer_29    14 1272
#> 435 Biome_Inventory_layer_29    17   37
#> 436 Biome_Inventory_layer_29    23  319
#> 437 Biome_Inventory_layer_29    24   16
#> 438 Biome_Inventory_layer_29    95    5
#> 439 Biome_Inventory_layer_30     1 5852
#> 440 Biome_Inventory_layer_30     2 1703
#> 441 Biome_Inventory_layer_30     3 3068
#> 442 Biome_Inventory_layer_30     4 2064
#> 443 Biome_Inventory_layer_30     5 1145
#> 444 Biome_Inventory_layer_30     6  220
#> 445 Biome_Inventory_layer_30     7  485
#> 446 Biome_Inventory_layer_30     8 1109
#> 447 Biome_Inventory_layer_30     9  386
#> 448 Biome_Inventory_layer_30    11  462
#> 449 Biome_Inventory_layer_31     1   13
#> 450 Biome_Inventory_layer_31     2 5050
#> 451 Biome_Inventory_layer_31     3 3060
#> 452 Biome_Inventory_layer_31     4 6224
#> 453 Biome_Inventory_layer_31     5  628
#> 454 Biome_Inventory_layer_31     6  229
#> 455 Biome_Inventory_layer_31     7  548
#> 456 Biome_Inventory_layer_31     8   82
#> 457 Biome_Inventory_layer_31    10  185
#> 458 Biome_Inventory_layer_31    12   22
#> 459 Biome_Inventory_layer_31    16  357
#> 460 Biome_Inventory_layer_31    19    1
#> 461 Biome_Inventory_layer_31    20   90
#> 462 Biome_Inventory_layer_31    95    5
# }
```
