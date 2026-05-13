# Tabulate the number of occurrences per biome

Summarizes the number of **occurrence records** (one row of `x` = one
occurrence) in each biome, for one or more biome layers. The output is a
long-format table with one row per (layer, biome) pair.

## Usage

``` r
biomes_biome_tab(x, value = "names")
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

A data frame with columns `layer`, `biome`, and `n` (the number of
occurrence records in that biome on that layer).

## Details

This function counts occurrences, not species. To count unique species
per biome, deduplicate by species before tabulating (e.g.
`dplyr::distinct(species, biome)` after combining classifications with
the original data).

## Examples

``` r
# Load example occurrence data
data("biomes_example")

# Tabulate by biome name
classified_names <- biomes_classify(
  x     = biomes_example,
  value = "name"
)
#> no biome file or layer provided using default biomes
#> Warning: Coordinates provided as data.frame, assuming WGS84 as CRS
#> Warning: [extract] transforming vector data to the CRS of the raster
#> Classified 29104 record(s) against 31 biome layer(s):
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
biomes_biome_tab(classified_names, value = "names")
#>                        layer
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
#> 17  Biome_Inventory_layer_01
#> 18  Biome_Inventory_layer_01
#> 19  Biome_Inventory_layer_01
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
#> 33  Biome_Inventory_layer_02
#> 34  Biome_Inventory_layer_02
#> 35  Biome_Inventory_layer_02
#> 36  Biome_Inventory_layer_02
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
#> 49  Biome_Inventory_layer_03
#> 50  Biome_Inventory_layer_03
#> 51  Biome_Inventory_layer_03
#> 52  Biome_Inventory_layer_03
#> 53  Biome_Inventory_layer_03
#> 54  Biome_Inventory_layer_03
#> 55  Biome_Inventory_layer_03
#> 56  Biome_Inventory_layer_03
#> 57  Biome_Inventory_layer_03
#> 58  Biome_Inventory_layer_03
#> 59  Biome_Inventory_layer_03
#> 60  Biome_Inventory_layer_03
#> 61  Biome_Inventory_layer_03
#> 62  Biome_Inventory_layer_04
#> 63  Biome_Inventory_layer_04
#> 64  Biome_Inventory_layer_04
#> 65  Biome_Inventory_layer_04
#> 66  Biome_Inventory_layer_04
#> 67  Biome_Inventory_layer_04
#> 68  Biome_Inventory_layer_04
#> 69  Biome_Inventory_layer_04
#> 70  Biome_Inventory_layer_04
#> 71  Biome_Inventory_layer_04
#> 72  Biome_Inventory_layer_04
#> 73  Biome_Inventory_layer_04
#> 74  Biome_Inventory_layer_04
#> 75  Biome_Inventory_layer_04
#> 76  Biome_Inventory_layer_04
#> 77  Biome_Inventory_layer_04
#> 78  Biome_Inventory_layer_04
#> 79  Biome_Inventory_layer_04
#> 80  Biome_Inventory_layer_04
#> 81  Biome_Inventory_layer_05
#> 82  Biome_Inventory_layer_05
#> 83  Biome_Inventory_layer_05
#> 84  Biome_Inventory_layer_05
#> 85  Biome_Inventory_layer_05
#> 86  Biome_Inventory_layer_05
#> 87  Biome_Inventory_layer_05
#> 88  Biome_Inventory_layer_05
#> 89  Biome_Inventory_layer_05
#> 90  Biome_Inventory_layer_05
#> 91  Biome_Inventory_layer_05
#> 92  Biome_Inventory_layer_05
#> 93  Biome_Inventory_layer_05
#> 94  Biome_Inventory_layer_05
#> 95  Biome_Inventory_layer_05
#> 96  Biome_Inventory_layer_06
#> 97  Biome_Inventory_layer_06
#> 98  Biome_Inventory_layer_06
#> 99  Biome_Inventory_layer_06
#> 100 Biome_Inventory_layer_06
#> 101 Biome_Inventory_layer_06
#> 102 Biome_Inventory_layer_06
#> 103 Biome_Inventory_layer_06
#> 104 Biome_Inventory_layer_06
#> 105 Biome_Inventory_layer_06
#> 106 Biome_Inventory_layer_06
#> 107 Biome_Inventory_layer_06
#> 108 Biome_Inventory_layer_06
#> 109 Biome_Inventory_layer_06
#> 110 Biome_Inventory_layer_07
#> 111 Biome_Inventory_layer_07
#> 112 Biome_Inventory_layer_07
#> 113 Biome_Inventory_layer_07
#> 114 Biome_Inventory_layer_07
#> 115 Biome_Inventory_layer_07
#> 116 Biome_Inventory_layer_07
#> 117 Biome_Inventory_layer_07
#> 118 Biome_Inventory_layer_07
#> 119 Biome_Inventory_layer_07
#> 120 Biome_Inventory_layer_07
#> 121 Biome_Inventory_layer_07
#> 122 Biome_Inventory_layer_08
#> 123 Biome_Inventory_layer_08
#> 124 Biome_Inventory_layer_08
#> 125 Biome_Inventory_layer_08
#> 126 Biome_Inventory_layer_08
#> 127 Biome_Inventory_layer_08
#> 128 Biome_Inventory_layer_08
#> 129 Biome_Inventory_layer_08
#> 130 Biome_Inventory_layer_08
#> 131 Biome_Inventory_layer_08
#> 132 Biome_Inventory_layer_08
#> 133 Biome_Inventory_layer_08
#> 134 Biome_Inventory_layer_08
#> 135 Biome_Inventory_layer_09
#> 136 Biome_Inventory_layer_09
#> 137 Biome_Inventory_layer_09
#> 138 Biome_Inventory_layer_09
#> 139 Biome_Inventory_layer_09
#> 140 Biome_Inventory_layer_09
#> 141 Biome_Inventory_layer_09
#> 142 Biome_Inventory_layer_09
#> 143 Biome_Inventory_layer_09
#> 144 Biome_Inventory_layer_09
#> 145 Biome_Inventory_layer_09
#> 146 Biome_Inventory_layer_09
#> 147 Biome_Inventory_layer_09
#> 148 Biome_Inventory_layer_09
#> 149 Biome_Inventory_layer_09
#> 150 Biome_Inventory_layer_09
#> 151 Biome_Inventory_layer_09
#> 152 Biome_Inventory_layer_09
#> 153 Biome_Inventory_layer_09
#> 154 Biome_Inventory_layer_09
#> 155 Biome_Inventory_layer_09
#> 156 Biome_Inventory_layer_09
#> 157 Biome_Inventory_layer_09
#> 158 Biome_Inventory_layer_09
#> 159 Biome_Inventory_layer_10
#> 160 Biome_Inventory_layer_10
#> 161 Biome_Inventory_layer_10
#> 162 Biome_Inventory_layer_10
#> 163 Biome_Inventory_layer_10
#> 164 Biome_Inventory_layer_10
#> 165 Biome_Inventory_layer_10
#> 166 Biome_Inventory_layer_10
#> 167 Biome_Inventory_layer_10
#> 168 Biome_Inventory_layer_10
#> 169 Biome_Inventory_layer_10
#> 170 Biome_Inventory_layer_10
#> 171 Biome_Inventory_layer_10
#> 172 Biome_Inventory_layer_10
#> 173 Biome_Inventory_layer_10
#> 174 Biome_Inventory_layer_10
#> 175 Biome_Inventory_layer_10
#> 176 Biome_Inventory_layer_10
#> 177 Biome_Inventory_layer_10
#> 178 Biome_Inventory_layer_10
#> 179 Biome_Inventory_layer_10
#> 180 Biome_Inventory_layer_10
#> 181 Biome_Inventory_layer_10
#> 182 Biome_Inventory_layer_10
#> 183 Biome_Inventory_layer_10
#> 184 Biome_Inventory_layer_10
#> 185 Biome_Inventory_layer_10
#> 186 Biome_Inventory_layer_10
#> 187 Biome_Inventory_layer_10
#> 188 Biome_Inventory_layer_10
#> 189 Biome_Inventory_layer_10
#> 190 Biome_Inventory_layer_11
#> 191 Biome_Inventory_layer_11
#> 192 Biome_Inventory_layer_11
#> 193 Biome_Inventory_layer_11
#> 194 Biome_Inventory_layer_11
#> 195 Biome_Inventory_layer_11
#> 196 Biome_Inventory_layer_11
#> 197 Biome_Inventory_layer_11
#> 198 Biome_Inventory_layer_11
#> 199 Biome_Inventory_layer_11
#> 200 Biome_Inventory_layer_11
#> 201 Biome_Inventory_layer_11
#> 202 Biome_Inventory_layer_12
#> 203 Biome_Inventory_layer_12
#> 204 Biome_Inventory_layer_12
#> 205 Biome_Inventory_layer_12
#> 206 Biome_Inventory_layer_12
#> 207 Biome_Inventory_layer_12
#> 208 Biome_Inventory_layer_12
#> 209 Biome_Inventory_layer_12
#> 210 Biome_Inventory_layer_12
#> 211 Biome_Inventory_layer_12
#> 212 Biome_Inventory_layer_12
#> 213 Biome_Inventory_layer_12
#> 214 Biome_Inventory_layer_12
#> 215 Biome_Inventory_layer_12
#> 216 Biome_Inventory_layer_12
#> 217 Biome_Inventory_layer_12
#> 218 Biome_Inventory_layer_13
#> 219 Biome_Inventory_layer_13
#> 220 Biome_Inventory_layer_13
#> 221 Biome_Inventory_layer_13
#> 222 Biome_Inventory_layer_13
#> 223 Biome_Inventory_layer_13
#> 224 Biome_Inventory_layer_13
#> 225 Biome_Inventory_layer_13
#> 226 Biome_Inventory_layer_13
#> 227 Biome_Inventory_layer_13
#> 228 Biome_Inventory_layer_13
#> 229 Biome_Inventory_layer_13
#> 230 Biome_Inventory_layer_13
#> 231 Biome_Inventory_layer_13
#> 232 Biome_Inventory_layer_13
#> 233 Biome_Inventory_layer_13
#> 234 Biome_Inventory_layer_13
#> 235 Biome_Inventory_layer_13
#> 236 Biome_Inventory_layer_13
#> 237 Biome_Inventory_layer_13
#> 238 Biome_Inventory_layer_13
#> 239 Biome_Inventory_layer_14
#> 240 Biome_Inventory_layer_14
#> 241 Biome_Inventory_layer_14
#> 242 Biome_Inventory_layer_14
#> 243 Biome_Inventory_layer_14
#> 244 Biome_Inventory_layer_14
#> 245 Biome_Inventory_layer_14
#> 246 Biome_Inventory_layer_14
#> 247 Biome_Inventory_layer_14
#> 248 Biome_Inventory_layer_14
#> 249 Biome_Inventory_layer_14
#> 250 Biome_Inventory_layer_14
#> 251 Biome_Inventory_layer_14
#> 252 Biome_Inventory_layer_14
#> 253 Biome_Inventory_layer_14
#> 254 Biome_Inventory_layer_14
#> 255 Biome_Inventory_layer_14
#> 256 Biome_Inventory_layer_14
#> 257 Biome_Inventory_layer_14
#> 258 Biome_Inventory_layer_15
#> 259 Biome_Inventory_layer_15
#> 260 Biome_Inventory_layer_15
#> 261 Biome_Inventory_layer_15
#> 262 Biome_Inventory_layer_15
#> 263 Biome_Inventory_layer_15
#> 264 Biome_Inventory_layer_15
#> 265 Biome_Inventory_layer_15
#> 266 Biome_Inventory_layer_15
#> 267 Biome_Inventory_layer_15
#> 268 Biome_Inventory_layer_15
#> 269 Biome_Inventory_layer_15
#> 270 Biome_Inventory_layer_16
#> 271 Biome_Inventory_layer_16
#> 272 Biome_Inventory_layer_16
#> 273 Biome_Inventory_layer_16
#> 274 Biome_Inventory_layer_16
#> 275 Biome_Inventory_layer_16
#> 276 Biome_Inventory_layer_16
#> 277 Biome_Inventory_layer_16
#> 278 Biome_Inventory_layer_16
#> 279 Biome_Inventory_layer_16
#> 280 Biome_Inventory_layer_16
#> 281 Biome_Inventory_layer_16
#> 282 Biome_Inventory_layer_16
#> 283 Biome_Inventory_layer_16
#> 284 Biome_Inventory_layer_16
#> 285 Biome_Inventory_layer_16
#> 286 Biome_Inventory_layer_16
#> 287 Biome_Inventory_layer_16
#> 288 Biome_Inventory_layer_16
#> 289 Biome_Inventory_layer_17
#> 290 Biome_Inventory_layer_17
#> 291 Biome_Inventory_layer_17
#> 292 Biome_Inventory_layer_17
#> 293 Biome_Inventory_layer_17
#> 294 Biome_Inventory_layer_17
#> 295 Biome_Inventory_layer_17
#> 296 Biome_Inventory_layer_17
#> 297 Biome_Inventory_layer_17
#> 298 Biome_Inventory_layer_17
#> 299 Biome_Inventory_layer_17
#> 300 Biome_Inventory_layer_17
#> 301 Biome_Inventory_layer_17
#> 302 Biome_Inventory_layer_17
#> 303 Biome_Inventory_layer_17
#> 304 Biome_Inventory_layer_17
#> 305 Biome_Inventory_layer_17
#> 306 Biome_Inventory_layer_17
#> 307 Biome_Inventory_layer_17
#> 308 Biome_Inventory_layer_17
#> 309 Biome_Inventory_layer_17
#> 310 Biome_Inventory_layer_18
#> 311 Biome_Inventory_layer_18
#> 312 Biome_Inventory_layer_18
#> 313 Biome_Inventory_layer_18
#> 314 Biome_Inventory_layer_18
#> 315 Biome_Inventory_layer_18
#> 316 Biome_Inventory_layer_18
#> 317 Biome_Inventory_layer_18
#> 318 Biome_Inventory_layer_18
#> 319 Biome_Inventory_layer_18
#> 320 Biome_Inventory_layer_18
#> 321 Biome_Inventory_layer_18
#> 322 Biome_Inventory_layer_18
#> 323 Biome_Inventory_layer_18
#> 324 Biome_Inventory_layer_18
#> 325 Biome_Inventory_layer_19
#> 326 Biome_Inventory_layer_19
#> 327 Biome_Inventory_layer_19
#> 328 Biome_Inventory_layer_19
#> 329 Biome_Inventory_layer_19
#> 330 Biome_Inventory_layer_19
#> 331 Biome_Inventory_layer_19
#> 332 Biome_Inventory_layer_19
#> 333 Biome_Inventory_layer_19
#> 334 Biome_Inventory_layer_19
#> 335 Biome_Inventory_layer_19
#> 336 Biome_Inventory_layer_19
#> 337 Biome_Inventory_layer_19
#> 338 Biome_Inventory_layer_19
#> 339 Biome_Inventory_layer_19
#> 340 Biome_Inventory_layer_19
#> 341 Biome_Inventory_layer_20
#> 342 Biome_Inventory_layer_20
#> 343 Biome_Inventory_layer_20
#> 344 Biome_Inventory_layer_20
#> 345 Biome_Inventory_layer_20
#> 346 Biome_Inventory_layer_20
#> 347 Biome_Inventory_layer_20
#> 348 Biome_Inventory_layer_20
#> 349 Biome_Inventory_layer_20
#> 350 Biome_Inventory_layer_20
#> 351 Biome_Inventory_layer_20
#> 352 Biome_Inventory_layer_20
#> 353 Biome_Inventory_layer_20
#> 354 Biome_Inventory_layer_20
#> 355 Biome_Inventory_layer_20
#> 356 Biome_Inventory_layer_20
#> 357 Biome_Inventory_layer_20
#> 358 Biome_Inventory_layer_20
#> 359 Biome_Inventory_layer_20
#> 360 Biome_Inventory_layer_20
#> 361 Biome_Inventory_layer_20
#> 362 Biome_Inventory_layer_20
#> 363 Biome_Inventory_layer_20
#> 364 Biome_Inventory_layer_20
#> 365 Biome_Inventory_layer_20
#> 366 Biome_Inventory_layer_20
#> 367 Biome_Inventory_layer_20
#> 368 Biome_Inventory_layer_21
#> 369 Biome_Inventory_layer_21
#> 370 Biome_Inventory_layer_21
#> 371 Biome_Inventory_layer_21
#> 372 Biome_Inventory_layer_21
#> 373 Biome_Inventory_layer_21
#> 374 Biome_Inventory_layer_21
#> 375 Biome_Inventory_layer_21
#> 376 Biome_Inventory_layer_21
#> 377 Biome_Inventory_layer_21
#> 378 Biome_Inventory_layer_21
#> 379 Biome_Inventory_layer_21
#> 380 Biome_Inventory_layer_21
#> 381 Biome_Inventory_layer_21
#> 382 Biome_Inventory_layer_21
#> 383 Biome_Inventory_layer_21
#> 384 Biome_Inventory_layer_21
#> 385 Biome_Inventory_layer_21
#> 386 Biome_Inventory_layer_21
#> 387 Biome_Inventory_layer_21
#> 388 Biome_Inventory_layer_21
#> 389 Biome_Inventory_layer_22
#> 390 Biome_Inventory_layer_22
#> 391 Biome_Inventory_layer_22
#> 392 Biome_Inventory_layer_22
#> 393 Biome_Inventory_layer_22
#> 394 Biome_Inventory_layer_22
#> 395 Biome_Inventory_layer_22
#> 396 Biome_Inventory_layer_22
#> 397 Biome_Inventory_layer_22
#> 398 Biome_Inventory_layer_22
#> 399 Biome_Inventory_layer_22
#> 400 Biome_Inventory_layer_22
#> 401 Biome_Inventory_layer_22
#> 402 Biome_Inventory_layer_22
#> 403 Biome_Inventory_layer_22
#> 404 Biome_Inventory_layer_22
#> 405 Biome_Inventory_layer_22
#> 406 Biome_Inventory_layer_22
#> 407 Biome_Inventory_layer_22
#> 408 Biome_Inventory_layer_22
#> 409 Biome_Inventory_layer_22
#> 410 Biome_Inventory_layer_22
#> 411 Biome_Inventory_layer_22
#> 412 Biome_Inventory_layer_22
#> 413 Biome_Inventory_layer_22
#> 414 Biome_Inventory_layer_22
#> 415 Biome_Inventory_layer_22
#> 416 Biome_Inventory_layer_23
#> 417 Biome_Inventory_layer_23
#> 418 Biome_Inventory_layer_23
#> 419 Biome_Inventory_layer_23
#> 420 Biome_Inventory_layer_23
#> 421 Biome_Inventory_layer_23
#> 422 Biome_Inventory_layer_23
#> 423 Biome_Inventory_layer_23
#> 424 Biome_Inventory_layer_23
#> 425 Biome_Inventory_layer_23
#> 426 Biome_Inventory_layer_23
#> 427 Biome_Inventory_layer_23
#> 428 Biome_Inventory_layer_23
#> 429 Biome_Inventory_layer_23
#> 430 Biome_Inventory_layer_23
#> 431 Biome_Inventory_layer_23
#> 432 Biome_Inventory_layer_24
#> 433 Biome_Inventory_layer_24
#> 434 Biome_Inventory_layer_24
#> 435 Biome_Inventory_layer_24
#> 436 Biome_Inventory_layer_24
#> 437 Biome_Inventory_layer_24
#> 438 Biome_Inventory_layer_24
#> 439 Biome_Inventory_layer_24
#> 440 Biome_Inventory_layer_24
#> 441 Biome_Inventory_layer_24
#> 442 Biome_Inventory_layer_24
#> 443 Biome_Inventory_layer_24
#> 444 Biome_Inventory_layer_24
#> 445 Biome_Inventory_layer_24
#> 446 Biome_Inventory_layer_24
#> 447 Biome_Inventory_layer_24
#> 448 Biome_Inventory_layer_25
#> 449 Biome_Inventory_layer_25
#> 450 Biome_Inventory_layer_25
#> 451 Biome_Inventory_layer_25
#> 452 Biome_Inventory_layer_25
#> 453 Biome_Inventory_layer_25
#> 454 Biome_Inventory_layer_25
#> 455 Biome_Inventory_layer_25
#> 456 Biome_Inventory_layer_25
#> 457 Biome_Inventory_layer_25
#> 458 Biome_Inventory_layer_25
#> 459 Biome_Inventory_layer_25
#> 460 Biome_Inventory_layer_26
#> 461 Biome_Inventory_layer_26
#> 462 Biome_Inventory_layer_26
#> 463 Biome_Inventory_layer_26
#> 464 Biome_Inventory_layer_26
#> 465 Biome_Inventory_layer_26
#> 466 Biome_Inventory_layer_26
#> 467 Biome_Inventory_layer_26
#> 468 Biome_Inventory_layer_26
#> 469 Biome_Inventory_layer_26
#> 470 Biome_Inventory_layer_26
#> 471 Biome_Inventory_layer_26
#> 472 Biome_Inventory_layer_26
#> 473 Biome_Inventory_layer_26
#> 474 Biome_Inventory_layer_26
#> 475 Biome_Inventory_layer_26
#> 476 Biome_Inventory_layer_26
#> 477 Biome_Inventory_layer_26
#> 478 Biome_Inventory_layer_26
#> 479 Biome_Inventory_layer_26
#> 480 Biome_Inventory_layer_26
#> 481 Biome_Inventory_layer_26
#> 482 Biome_Inventory_layer_26
#> 483 Biome_Inventory_layer_26
#> 484 Biome_Inventory_layer_26
#> 485 Biome_Inventory_layer_26
#> 486 Biome_Inventory_layer_26
#> 487 Biome_Inventory_layer_26
#> 488 Biome_Inventory_layer_26
#> 489 Biome_Inventory_layer_26
#> 490 Biome_Inventory_layer_26
#> 491 Biome_Inventory_layer_26
#> 492 Biome_Inventory_layer_26
#> 493 Biome_Inventory_layer_26
#> 494 Biome_Inventory_layer_26
#> 495 Biome_Inventory_layer_26
#> 496 Biome_Inventory_layer_26
#> 497 Biome_Inventory_layer_27
#> 498 Biome_Inventory_layer_27
#> 499 Biome_Inventory_layer_27
#> 500 Biome_Inventory_layer_27
#> 501 Biome_Inventory_layer_27
#> 502 Biome_Inventory_layer_27
#> 503 Biome_Inventory_layer_27
#> 504 Biome_Inventory_layer_27
#> 505 Biome_Inventory_layer_27
#> 506 Biome_Inventory_layer_27
#> 507 Biome_Inventory_layer_27
#> 508 Biome_Inventory_layer_27
#> 509 Biome_Inventory_layer_27
#> 510 Biome_Inventory_layer_27
#> 511 Biome_Inventory_layer_27
#> 512 Biome_Inventory_layer_27
#> 513 Biome_Inventory_layer_28
#> 514 Biome_Inventory_layer_28
#> 515 Biome_Inventory_layer_28
#> 516 Biome_Inventory_layer_28
#> 517 Biome_Inventory_layer_28
#> 518 Biome_Inventory_layer_28
#> 519 Biome_Inventory_layer_28
#> 520 Biome_Inventory_layer_28
#> 521 Biome_Inventory_layer_28
#> 522 Biome_Inventory_layer_28
#> 523 Biome_Inventory_layer_28
#> 524 Biome_Inventory_layer_28
#> 525 Biome_Inventory_layer_28
#> 526 Biome_Inventory_layer_28
#> 527 Biome_Inventory_layer_28
#> 528 Biome_Inventory_layer_29
#> 529 Biome_Inventory_layer_29
#> 530 Biome_Inventory_layer_29
#> 531 Biome_Inventory_layer_29
#> 532 Biome_Inventory_layer_29
#> 533 Biome_Inventory_layer_29
#> 534 Biome_Inventory_layer_29
#> 535 Biome_Inventory_layer_29
#> 536 Biome_Inventory_layer_29
#> 537 Biome_Inventory_layer_29
#> 538 Biome_Inventory_layer_29
#> 539 Biome_Inventory_layer_29
#> 540 Biome_Inventory_layer_29
#> 541 Biome_Inventory_layer_29
#> 542 Biome_Inventory_layer_29
#> 543 Biome_Inventory_layer_29
#> 544 Biome_Inventory_layer_29
#> 545 Biome_Inventory_layer_29
#> 546 Biome_Inventory_layer_29
#> 547 Biome_Inventory_layer_29
#> 548 Biome_Inventory_layer_29
#> 549 Biome_Inventory_layer_29
#> 550 Biome_Inventory_layer_29
#> 551 Biome_Inventory_layer_29
#> 552 Biome_Inventory_layer_29
#> 553 Biome_Inventory_layer_29
#> 554 Biome_Inventory_layer_29
#> 555 Biome_Inventory_layer_29
#> 556 Biome_Inventory_layer_29
#> 557 Biome_Inventory_layer_29
#> 558 Biome_Inventory_layer_30
#> 559 Biome_Inventory_layer_30
#> 560 Biome_Inventory_layer_30
#> 561 Biome_Inventory_layer_30
#> 562 Biome_Inventory_layer_30
#> 563 Biome_Inventory_layer_30
#> 564 Biome_Inventory_layer_30
#> 565 Biome_Inventory_layer_30
#> 566 Biome_Inventory_layer_30
#> 567 Biome_Inventory_layer_30
#> 568 Biome_Inventory_layer_30
#> 569 Biome_Inventory_layer_30
#> 570 Biome_Inventory_layer_30
#> 571 Biome_Inventory_layer_31
#> 572 Biome_Inventory_layer_31
#> 573 Biome_Inventory_layer_31
#> 574 Biome_Inventory_layer_31
#> 575 Biome_Inventory_layer_31
#> 576 Biome_Inventory_layer_31
#> 577 Biome_Inventory_layer_31
#> 578 Biome_Inventory_layer_31
#> 579 Biome_Inventory_layer_31
#> 580 Biome_Inventory_layer_31
#> 581 Biome_Inventory_layer_31
#> 582 Biome_Inventory_layer_31
#> 583 Biome_Inventory_layer_31
#> 584 Biome_Inventory_layer_31
#> 585 Biome_Inventory_layer_31
#> 586 Biome_Inventory_layer_31
#> 587 Biome_Inventory_layer_31
#> 588 Biome_Inventory_layer_31
#> 589 Biome_Inventory_layer_31
#> 590 Biome_Inventory_layer_31
#> 591 Biome_Inventory_layer_31
#> 592 Biome_Inventory_layer_31
#> 593 Biome_Inventory_layer_31
#> 594 Biome_Inventory_layer_31
#> 595 Biome_Inventory_layer_31
#> 596 Biome_Inventory_layer_31
#> 597 Biome_Inventory_layer_31
#> 598 Biome_Inventory_layer_31
#> 599 Biome_Inventory_layer_31
#> 600 Biome_Inventory_layer_31
#> 601 Biome_Inventory_layer_31
#> 602 Biome_Inventory_layer_31
#> 603 Biome_Inventory_layer_31
#>                                                                                                   biome
#> 1                                                                    Boreal evergreen needleleaf forest
#> 2                                                                                       Boreal parkland
#> 3                                                                   Boreal summergreen broadleaf forest
#> 4                                                                                                Desert
#> 5                                                                                               Savanna
#> 6                                                                                            Semidesert
#> 7                                                                                          Shrub tundra
#> 8                                                                                                Steppe
#> 9                                                                  Temperate broadleaf evergreen forest
#> 10                                                                               Temperate mixed forest
#> 11                                                                Temperate needleleaf evergreen forest
#> 12                                                                                   Temperate parkland
#> 13                                                                                  Temperate shrubland
#> 14                                                                         Temperate summergreen forest
#> 15                                                                            Tropical evergreen forest
#> 16                                                                                   Tropical grassland
#> 17                                                                            Tropical raingreen forest
#> 18                                                                                               Tundra
#> 19                                                                              Warm temperate woodland
#> 20                                                                          Bare soil/sparse vegetation
#> 21                                                                  Closed forest (deciduous broadleaf)
#> 22                                                                 Closed forest (deciduous needleleaf)
#> 23                                                                  Closed forest (evergreen broadleaf)
#> 24                                                                 Closed forest (evergreen needleleaf)
#> 25                                                                                Closed forest (mixed)
#> 26                                                                              Closed forest (unknown)
#> 27                                             Cultivated and managed vegetation/agriculture (cropland)
#> 28                                                                                Herbaceous vegetation
#> 29                                                                                   Herbaceous wetland
#> 30                                                                    Open forest (deciduous broadleaf)
#> 31                                                                   Open forest (evergreen needleleaf)
#> 32                                                                                Open forest (unknown)
#> 33                                                                                               Shrubs
#> 34                                                                                         Snow and ice
#> 35                                                                            azonal (raster value: 95)
#> 36                                                                            azonal (raster value: 98)
#> 37                                                                             Af - Tropical rainforest
#> 38                                                                                Am - Tropical monsoon
#> 39                                                                                Aw - Tropical savanna
#> 40                                                                                BSh - Arid steppe hot
#> 41                                                                               BSk - Arid steppe cold
#> 42                                                                                BWh - Arid desert hot
#> 43                                                                               BWk - Arid desert cold
#> 44                                                             Cfa - Temperate no dry season hot summer
#> 45                                                            Cfb - Temperate no dry season warm summer
#> 46                                                            Cfc - Temperate no dry season cold summer
#> 47                                                                Csa - Temperate dry summer hot summer
#> 48                                                               Csb - Temperate dry summer warm summer
#> 49                                                                Cwa - Temperate dry winter hot summer
#> 50                                                               Cwb - Temperate dry winter warm summer
#> 51                                                                  Dfa - Cold no dry season hot summer
#> 52                                                                 Dfb - Cold no dry season warm summer
#> 53                                                                 Dfc - Cold no dry season cold summer
#> 54                                                                     Dsa - Cold dry summer hot summer
#> 55                                                                    Dsb - Cold dry summer warm summer
#> 56                                                                    Dsc - Cold dry summer cold summer
#> 57                                                                     Dwa - Cold dry winter hot summer
#> 58                                                                    Dwb - Cold dry winter warm summer
#> 59                                                                    Dwc - Cold dry winter cold summer
#> 60                                                                                     EF - Polar frost
#> 61                                                                                    ET - Polar tundra
#> 62                                                                                Cold deciduous forest
#> 63                                                                     Cold evergreen needleleaf forest
#> 64                                                                     Cool evergreen needleleaf forest
#> 65                                                                                    Cool mixed forest
#> 66                                                                            Cool temperate rainforest
#> 67                                                                                               Desert
#> 68                                                                             Erect dwarf shrub tundra
#> 69                                                                            Graminoid and forb tundra
#> 70                                                                            Low and high shrub tundra
#> 71                                                                                               Steppe
#> 72                                                                 Temperate deciduous broadleaf forest
#> 73                                                         Temperate evergreen needleleaf open woodland
#> 74                                                         Temperate sclerophyll woodland and shrubland
#> 75                                                     Tropical deciduous broadleaf forest and woodland
#> 76                                                                  Tropical evergreen broadleaf forest
#> 77                                                                                     Tropical savanna
#> 78                                                             Tropical semi-evergreen broadleaf forest
#> 79                                                            Warm temperate evergreen and mixed forest
#> 80                                                                            Xerophytic woodland scrub
#> 81                                                                                  Boreal forest/taiga
#> 82                                                                          Deserts and xeric shrubland
#> 83                                                                        Flooded grassland and savanna
#> 84                                                                                             Mangrove
#> 85                                                             Mediterranean forest woodland and scrub 
#> 86                                                                      Montane grassland and shrubland
#> 87                                                                                         Rock and ice
#> 88                                                                 Temperate broadleaf and mixed forest
#> 89                                                                             Temperate conifer forest
#> 90                                                            Temperate grassland savanna and shrubland
#> 91                                                           Tropical and subtropical coniferous forest
#> 92                                                        Tropical and subtropical dry broadleaf forest
#> 93                                             Tropical and subtropical grassland savanna and shrubland
#> 94                                                      Tropical and subtropical moist broadleaf forest
#> 95                                                                                               Tundra
#> 96                                                                   Frigid deciduous coniferous forest
#> 97                                                                   Frigid evergreen coniferous forest
#> 98                                                                                          Polar frost
#> 99                                                                                         Polar tundra
#> 100                                                                             Sub-frigid mixed forest
#> 101                                                 Temperate continental climate with deciduous forest
#> 102                                                                                    Temperate desert
#> 103                                                                                 Temperate grassland
#> 104                                          Temperate maritime climate with evergreen broadleaf forest
#> 105                                                               Tropical Sahel and semiarid grassland
#> 106                                                                                     Tropical desert
#> 107                                                                                     Tropical forest
#> 108                                                                                  Tropical grassland
#> 109                                                                             Tropical monsoon forest
#> 110                                                                                          Cluster 10
#> 111                                                                                          Cluster 11
#> 112                                                                                          Cluster 12
#> 113                                                                                          Cluster 13
#> 114                                                                                           Cluster 2
#> 115                                                                                           Cluster 3
#> 116                                                                                           Cluster 4
#> 117                                                                                           Cluster 5
#> 118                                                                                           Cluster 6
#> 119                                                                                           Cluster 7
#> 120                                                                                           Cluster 8
#> 121                                                                                           Cluster 9
#> 122                                                                                           Cluster 1
#> 123                                                                                          Cluster 10
#> 124                                                                                          Cluster 11
#> 125                                                                                          Cluster 12
#> 126                                                                                          Cluster 13
#> 127                                                                                           Cluster 2
#> 128                                                                                           Cluster 3
#> 129                                                                                           Cluster 4
#> 130                                                                                           Cluster 5
#> 131                                                                                           Cluster 6
#> 132                                                                                           Cluster 7
#> 133                                                                                           Cluster 8
#> 134                                                                                           Cluster 9
#> 135                                                                                                 SHB
#> 136                                                                                                 SHC
#> 137                                                                                                 SHD
#> 138                                                                                                 SHN
#> 139                                                                                                 SLB
#> 140                                                                                                 SLC
#> 141                                                                                                 SLD
#> 142                                                                                                 SLN
#> 143                                                                                                 SMB
#> 144                                                                                                 SMC
#> 145                                                                                                 SMD
#> 146                                                                                                 SMN
#> 147                                                                                                 THB
#> 148                                                                                                 THC
#> 149                                                                                                 THD
#> 150                                                                                                 THN
#> 151                                                                                                 TLB
#> 152                                                                                                 TLC
#> 153                                                                                                 TLD
#> 154                                                                                                 TLN
#> 155                                                                                                 TMB
#> 156                                                                                                 TMC
#> 157                                                                                                 TMD
#> 158                                                                                                 TMN
#> 159                                                  Evergreen and seasonal tropical lowland rainforest
#> 160                                                 Evergreen and summergreen forest, tall-grass steppe
#> 161                                                                  Evergreen boreal coniferous forest
#> 162                                                                               Evergreen dry savanna
#> 163                                                                             Evergreen moist savanna
#> 164                                                                 Evergreen nemoral Nothofagus forest
#> 165                                                                 Evergreen nemoral coniferous forest
#> 166                                                                     Evergreen nemoral laural forest
#> 167                                                                 Evergreen subtropical laurel forest
#> 168                                                        Hemiboreal deciduous coniferous mixed forest
#> 169                                                                     High mountian steppe semidesert
#> 170                                                                          Mixed and low-grass steppe
#> 171                                                                                      Nemoral desert
#> 172                                                                                  Nemoral dry forest
#> 173                                                                       Nemoral dwarf bush semidesert
#> 174                                                                   Polar gras and dwarf shrub tundra
#> 175                                                                               Raingreen dry savanna
#> 176                                                                             Raingreen moist savanna
#> 177                                                        Semievergreen and raingreen deciduous forest
#> 178                                                                               Subtropical grassland
#> 179                                                                      Subtropical sclerophyll forest
#> 180                                                                 Summergreen boreal deciduous forest
#> 181                                                                Summergreen nemoral deciduous forest
#> 182                                                                         Tropical-subtropical desert
#> 183                                                                     Tropical-subtropical dry forest
#> 184                                                          Tropical-subtropical dwarf bush semidesert
#> 185                                                               Tropical-subtropical grass semidesert
#> 186                                                           Tropical-subtropical succulent semidesert
#> 187                                                                           azonal (raster value: 95)
#> 188                                                                           azonal (raster value: 96)
#> 189                                                                           azonal (raster value: 97)
#> 190                                                                  Frigid deciduous coniferous forest
#> 191                                                                                        Polar tundra
#> 192                                                                             Sub-frigid mixed forest
#> 193                                                 Temperate continental climate with deciduous forest
#> 194                                                                                    Temperate desert
#> 195                                                                                 Temperate grassland
#> 196                                          Temperate maritime climate with evergreen broadleaf forest
#> 197                                                               Tropical Sahel and semiarid grassland
#> 198                                                                                     Tropical desert
#> 199                                                                                     Tropical forest
#> 200                                                                                  Tropical grassland
#> 201                                                                             Tropical monsoon forest
#> 202                                                                                              Arctic
#> 203                                                                                      Cold and mesic
#> 204                                                                                        Cold and wet
#> 205                                                                              Cool temperate and dry
#> 206                                                                            Cool temperate and moist
#> 207                                                                            Cool temperate and xeric
#> 208                                                                            Extremely cold and mesic
#> 209                                                                              Extremely cold and wet
#> 210                                                                              Extremely hot and arid
#> 211                                                                             Extremely hot and moist
#> 212                                                                             Extremely hot and xeric
#> 213                                                                                        Hot and arid
#> 214                                                                                         Hot and dry
#> 215                                                                                       Hot and mesic
#> 216                                                                            Warm temperate and mesic
#> 217                                                                            Warm temperate and xeric
#> 218                                                                            Boreal coniferous forest
#> 219                                                                              Boreal mountain system
#> 220                                                                              Boreal tundra woodland
#> 221                                                                                               Polar
#> 222                                                                                  Subtropical desert
#> 223                                                                              Subtropical dry forest
#> 224                                                                            Subtropical humid forest
#> 225                                                                         Subtropical mountain system
#> 226                                                                                  Subtropical steppe
#> 227                                                                        Temperate continental forest
#> 228                                                                                    Temperate desert
#> 229                                                                           Temperate mountain system
#> 230                                                                            Temperate oceanic forest
#> 231                                                                                    Temperate steppe
#> 232                                                                                     Tropical desert
#> 233                                                                                 Tropical dry forest
#> 234                                                                               Tropical moist forest
#> 235                                                                            Tropical mountain system
#> 236                                                                                 Tropical rainforest
#> 237                                                                                  Tropical shrubland
#> 238                                                                           azonal (raster value: 95)
#> 239                                                          Bare soil - consolidated (gravel and rock)
#> 240                                                                   Bare soil - unconsolidated (sand)
#> 241                                                                          Broadleaf deciduous forest
#> 242                                                                          Broadleaf evergreen forest
#> 243                                                                                            Cropland
#> 244                                                                    Cropland/other vegetation mosaic
#> 245                                                                                          Herbaceous
#> 246                                                                   Herbaceous with sparse tree/shrub
#> 247                                                                                            Mangrove
#> 248                                                                                        Mixed forest
#> 249                                                                         Needleleaf deciduous forest
#> 250                                                                         Needleleaf evergreen forest
#> 251                                                                                         Paddy field
#> 252                                                                                               Shrub
#> 253                                                                                        Snow and ice
#> 254                                                                                   Sparse vegetation
#> 255                                                                                           Tree open
#> 256                                                                                             Wetland
#> 257                                                                           azonal (raster value: 98)
#> 258                                                                                              Barren
#> 259                                                                           Closed bushland/shrubland
#> 260                                                                                            Cropland
#> 261                                                                          Deciduous broadleaf forest
#> 262                                                                          Evergreen broadleaf forest
#> 263                                                                         Evergreen needleleaf forest
#> 264                                                                                           Grassland
#> 265                                                                                        Mixed forest
#> 266                                                                                      Open shrubland
#> 267                                                                          Wooded grassland shrubland
#> 268                                                                                            Woodland
#> 269                                                                           azonal (raster value: 98)
#> 270                                                                  Inhabited treeless and barren land
#> 271                                                                                  Irrigated villages
#> 272                                                                                   Mixed settlements
#> 273                                                                                   Pastoral villages
#> 274                                                                                  Populated cropland
#> 275                                                                                 Populated rangeland
#> 276                                                                                  Populated woodland
#> 277                                                                                    Rainfed villages
#> 278                                                                                     Remote cropland
#> 279                                                                                    Remote rangeland
#> 280                                                                                     Remote woodland
#> 281                                                                      Residential irrigated cropland
#> 282                                                                        Residential rainfed cropland
#> 283                                                                               Residential rangeland
#> 284                                                                                Residential woodland
#> 285                                                                                       Rice villages
#> 286                                                                       Wild treeless and barren land
#> 287                                                                                       Wild woodland
#> 288                                                                           azonal (raster value: 98)
#> 289                                                                                           Bare soil
#> 290                                                      Closed (>40%) broadleaf deciduous forest (>5m)
#> 291             Closed (>40%) broadleaf forest or shrubland permanently flooded (saline/brackish water)
#> 292                                                     Closed (>40%) needleleaf evergreen forest (>5m)
#> 293              Closed to open (>15%) (broadleaf or needleleaf evergreen or deciduous) shrubland (<5m)
#> 294                            Closed to open (>15%) broadleaf evergreen or semi-deciduous forest (>5m)
#> 295                     Closed to open (>15%) broadleaf forest regularly flooded (fresh/brackish water)
#> 296 Closed to open (>15%) grassland or woody vegetation regularly flooded (fresh/brackish/saline water)
#> 297                      Closed to open (>15%) herbaceous vegetation (grassland savanna or lichen/moss)
#> 298                                   Closed to open (>15%) mixed broadleaf and needleleaf forest (>5m)
#> 299                           Mosaic cropland (50-70%)/vegetation (grassland/shrubland/forest) (20-50%)
#> 300                                              Mosaic forest or shrubland (50-70%)/grassland (20-50%)
#> 301                                              Mosaic grassland (50-70%)/forest or shrubland (20-50%)
#> 302                           Mosaic vegetation (grassland/shrubland/forest) (50-70%)/cropland (20-50%)
#> 303                                             Open (15-40%) broadleaf deciduous forest/woodland (>5m)
#> 304                                        Open (15-40%) needleleaf deciduous or evergreen forest (>5m)
#> 305                                                    Post-flooding or irrigated cropland (or aquatic)
#> 306                                                                                    Rainfed cropland
#> 307                                                                                        Snow and ice
#> 308                                                                            Sparse (<15%) vegetation
#> 309                                                                           azonal (raster value: 98)
#> 310                                                                                              Barren
#> 311                                                                                    Closed shrubland
#> 312                                                                                            Cropland
#> 313                                                                  Cropland/natural vegetation mosaic
#> 314                                                                          Deciduous broadleaf forest
#> 315                                                                          Evergreen broadleaf forest
#> 316                                                                         Evergreen needleleaf forest
#> 317                                                                                           Grassland
#> 318                                                                                        Mixed forest
#> 319                                                                                      Open shrubland
#> 320                                                                                   Permanent wetland
#> 321                                                                                             Savanna
#> 322                                                                                        Snow and ice
#> 323                                                                                       Woody savanna
#> 324                                                                           azonal (raster value: 98)
#> 325                                                                                 Boreal forest/taiga
#> 326                                                                              Desert and xeric shrub
#> 327                                                                       Flooded grassland and savanna
#> 328                                                                                            Mangrove
#> 329                                                             Mediterranean forest woodland and scrub
#> 330                                                                         Montane grassland and shrub
#> 331                                                                                        Rock and ice
#> 332                                                                Temperate broadleaf and mixed forest
#> 333                                                                            Temperate conifer forest
#> 334                                                               Temperate grassland savanna and shrub
#> 335                                                              Tropical subtropical coniferous forest
#> 336                                                           Tropical subtropical dry broadleaf forest
#> 337                                                    Tropical subtropical grassland savanna and shrub
#> 338                                                         Tropical subtropical moist broadleaf forest
#> 339                                                                                              Tundra
#> 340                                                                           azonal (raster value: 95)
#> 341                                                                            Af - Tropical rainforest
#> 342                                                                               Am - Tropical monsoon
#> 343                                                                               Aw - Tropical savanna
#> 344                                                                               BSh - Arid steppe hot
#> 345                                                                              BSk - Arid steppe cold
#> 346                                                                               BWh - Arid desert hot
#> 347                                                                              BWk - Arid desert cold
#> 348                                                            Cfa - Temperate no dry season hot summer
#> 349                                                           Cfb - Temperate no dry season warm summer
#> 350                                                           Cfc - Temperate no dry season cold summer
#> 351                                                               Csa - Temperate dry summer hot summer
#> 352                                                              Csb - Temperate dry summer warm summer
#> 353                                                               Cwa - Temperate dry winter hot summer
#> 354                                                              Cwb - Temperate dry winter warm summer
#> 355                                                                 Dfa - Cold no dry season hot summer
#> 356                                                                Dfb - Cold no dry season warm summer
#> 357                                                                Dfc - Cold no dry season cold summer
#> 358                                                                    Dsa - Cold dry summer hot summer
#> 359                                                                   Dsb - Cold dry summer warm summer
#> 360                                                                   Dsc - Cold dry summer cold summer
#> 361                                                                    Dwa - Cold dry winter hot summer
#> 362                                                                   Dwb - Cold dry winter warm summer
#> 363                                                                   Dwc - Cold dry winter cold summer
#> 364                                                                                    EF - Polar frost
#> 365                                                                          EFH - Polar frost highland
#> 366                                                                                   ET - Polar tundra
#> 367                                                                         ETH - Polar tundra highland
#> 368                                                                                           Bare soil
#> 369                                                                         Cultivated and managed area
#> 370                                                                      Herbaceous cover (closed-open)
#> 371                                                                         Mosaic cropland/shrub/grass
#> 372                                                 Mosaic cropland/tree cover/other natural vegetation
#> 373                                                          Mosaic tree cover/other natural vegetation
#> 374                                                            Regularly flooded shrub/herbaceous cover
#> 375                                                                 Shrub cover (closed-open deciduous)
#> 376                                                                 Shrub cover (closed-open evergreen)
#> 377                                                                                        Snow and ice
#> 378                                                                       Sparse herbaceous/shrub cover
#> 379                                                             Tree cover (broadleaf deciduous closed)
#> 380                                                               Tree cover (broadleaf deciduous open)
#> 381                                                                    Tree cover (broadleaf evergreen)
#> 382                                                                                  Tree cover (burnt)
#> 383                                                                        Tree cover (mixed leaf type)
#> 384                                                                   Tree cover (needleleaf deciduous)
#> 385                                                                   Tree cover (needleleaf evergreen)
#> 386                                                          Tree cover (regularly flooded fresh water)
#> 387                                                         Tree cover (regularly flooded saline water)
#> 388                                                                           azonal (raster value: 98)
#> 389                                                                                              Barren
#> 390                                                                                   Cold mixed forest
#> 391                                                                                 Cool conifer forest
#> 392                                                                                   Cool mixed forest
#> 393                                                                       Cushion-forbs lichen and moss
#> 394                                                                      Deciduous taiga/montane forest
#> 395                                                                                              Desert
#> 396                                                                                  Dwarf shrub tundra
#> 397                                                                       Evegreen taiga/montane forest
#> 398                                                                               Open conifer woodland
#> 399                                                                              Prostrate shrub tundra
#> 400                                                                                        Shrub tundra
#> 401                                                                                        Snow and ice
#> 402                                                                                       Steppe tundra
#> 403                                                                         Temperate broadleaf savanna
#> 404                                                                            Temperate conifer forest
#> 405                                                                          Temperate deciduous forest
#> 406                                                                                 Temperate grassland
#> 407                                                                      Temperate sclerophyll woodland
#> 408                                                                      Temperate xerophytic shrubland
#> 409                                                                  Tropical deciduous forest/woodland
#> 410                                                                           Tropical evergreen forest
#> 411                                                                                  Tropical grassland
#> 412                                                                                    Tropical savanna
#> 413                                                                      Tropical semi-deciduous forest
#> 414                                                                       Tropical xerophytic shrubland
#> 415                                                                                   Warm mixed forest
#> 416                                                                                 Boreal forest/taiga
#> 417                                                                         Deserts and xeric shrubland
#> 418                                                                       Flooded grassland and savanna
#> 419                                                                                            Mangrove
#> 420                                                             Mediterranean forest woodland and scrub
#> 421                                                                     Montane grassland and shrubland
#> 422                                                                                        Snow and ice
#> 423                                                                Temperate broadleaf and mixed forest
#> 424                                                                            Temperate conifer forest
#> 425                                                           Temperate grassland savanna and shrubland
#> 426                                                          Tropical and subtropical coniferous forest
#> 427                                                       Tropical and subtropical dry broadleaf forest
#> 428                                            Tropical and subtropical grassland savanna and shrubland
#> 429                                                     Tropical and subtropical moist broadleaf forest
#> 430                                                                                              Tundra
#> 431                                                                           azonal (raster value: 95)
#> 432                                                                                        Bare surface
#> 433                                                                                        Closed shrub
#> 434                                                                             Crop/natural vegetation
#> 435                                                                                            Cropland
#> 436                                                                                 Deciduous broadleaf
#> 437                                                                                Deciduous needleleaf
#> 438                                                                                 Evergreen broadleaf
#> 439                                                                                Evergreen needleleaf
#> 440                                                                                           Grassland
#> 441                                                                                                 Ice
#> 442                                                                                        Mixed forest
#> 443                                                                                          Open shrub
#> 444                                                                                             Savanna
#> 445                                                                                            Wetlands
#> 446                                                                                       Woody savanna
#> 447                                                                           azonal (raster value: 98)
#> 448                                                                                     Boreal woodland
#> 449                                                                                     Dense shrubland
#> 450                                                                                   Desert and barren
#> 451                                                                                Grassland and steppe
#> 452                                                                                      Mixed woodland
#> 453                                                                                      Open shrubland
#> 454                                                                                             Savanna
#> 455                                                                        Temperate deciduous woodland
#> 456                                                                        Temperate evergreen woodland
#> 457                                                                         Tropical deciduous woodland
#> 458                                                                         Tropical evergreen woodland
#> 459                                                                                              Tundra
#> 460                                                                                       Boreal desert
#> 461                                                                                     Boreal dry bush
#> 462                                                                                 Boreal moist forest
#> 463                                                                                   Boreal rainforest
#> 464                                                                                   Boreal wet forest
#> 465                                                                               Cool temperate desert
#> 466                                                                          Cool temperate desert bush
#> 467                                                                         Cool temperate moist forest
#> 468                                                                           Cool temperate rainforest
#> 469                                                                               Cool temperate steppe
#> 470                                                                           Cool temperate wet forest
#> 471                                                                                                 Ice
#> 472                                                                                        Polar desert
#> 473                                                                                    Polar dry tundra
#> 474                                                                                  Polar moist tundra
#> 475                                                                                   Polar rain tundra
#> 476                                                                                    Polar wet tundra
#> 477                                                                                  Subtropical desert
#> 478                                                                             Subtropical desert bush
#> 479                                                                              Subtropical dry forest
#> 480                                                                            Subtropical moist forest
#> 481                                                                              Subtropical rainforest
#> 482                                                                            Subtropical thorn steppe
#> 483                                                                              Subtropical wet forest
#> 484                                                                                     Tropical desert
#> 485                                                                                 Tropical dry forest
#> 486                                                                               Tropical moist forest
#> 487                                                                               Tropical thorn steppe
#> 488                                                                            Tropical very dry forest
#> 489                                                                                 Tropical wet forest
#> 490                                                                               Warm temperate desert
#> 491                                                                          Warm temperate desert bush
#> 492                                                                           Warm temperate dry forest
#> 493                                                                         Warm temperate moist forest
#> 494                                                                         Warm temperate thorn steppe
#> 495                                                                           Warm temperate wet forest
#> 496                                                                           azonal (raster value: 95)
#> 497                                                                                              Boreal
#> 498                                                                         Continuous moist subtropics
#> 499                                                                            Continuous moist tropics
#> 500                                                                                         Dry savanna
#> 501                                                                                 Moist mid-latitudes
#> 502                                                                                       Moist savanna
#> 503                                                                        Summer moist xeric shrubland
#> 504                                                                                    Temperate desert
#> 505                                                                                    Temperate steppe
#> 506                                                                         Tropical-subtropical desert
#> 507                                                                                              Tundra
#> 508                                                                                 Winter moist steppe
#> 509                                                                             Winter moist subtropics
#> 510                                                                           azonal (raster value: 95)
#> 511                                                                           azonal (raster value: 96)
#> 512                                                                           azonal (raster value: 97)
#> 513                                                                               Desert and semidesert
#> 514                                                                 Dry savanna and tropical dry forest
#> 515                                                                                          Dry steppe
#> 516                                                                                      Dry zone oasis
#> 517                                                                                       Moist savanna
#> 518                                                                                        Rock and ice
#> 519                                                                           Temperate forest and bush
#> 520                                                                     Temperate grassland and pasture
#> 521                                                                                             Tillage
#> 522                                                                                Tropical agriculture
#> 523                                                                           Tropical pasture highland
#> 524                                                                                 Tropical rainforest
#> 525                                                                                              Tundra
#> 526                                                                           azonal (raster value: 95)
#> 527                                                                           azonal (raster value: 96)
#> 528                                                                                Coniferous dry shrub
#> 529                                                                                          Dry desert
#> 530                                                                                         Dry savanna
#> 531                                                              Dry steppe and hard cushion formations
#> 532                                                                  Evergreen boreal coniferous forest
#> 533                                                            Laurel forest and subtropical rainforest
#> 534                                                                                       Moist savanna
#> 535                                                                          Mountain coniferous forest
#> 536                                                                                 Mountain vegetation
#> 537                                                                           Paramo heath and wet Puna
#> 538                                                                              Sclerophyll vegetation
#> 539                                                                                          Semidesert
#> 540                                                                                  Subantarctic heath
#> 541                                                              Subpolar meadow and summer green shrub
#> 542                                                                      Summer green coniferous forest
#> 543                                                                       Summer green deciduous forest
#> 544                                                         Summer green deciduous forest with conifers
#> 545                                                                            Summer green tree steppe
#> 546                                                                                Temperate rainforest
#> 547                                                                          Thorn and succulent forest
#> 548                                                                                       Thorn savanna
#> 549                                                                          Thorn shrub and succulents
#> 550                                                                                   Transition steppe
#> 551                                                                                 Tropical dry forest
#> 552                                                                        Tropical mountain rainforest
#> 553                                                                                 Tropical rainforest
#> 554                                                                  Tropical semi-evergreen rainforest
#> 555                                                                                              Tundra
#> 556                                                                           azonal (raster value: 95)
#> 557                                                                           azonal (raster value: 96)
#> 558                                                                                       Boreal forest
#> 559                                                                               Desert and semidesert
#> 560                                                                                       Mediterranean
#> 561                                                                                    Temperate forest
#> 562                                                                                 Temperate grassland
#> 563                                                                                 Tropical rainforest
#> 564                                                                                    Tropical savanna
#> 565                                                                            Tropical seasonal forest
#> 566                                                                                  Tropical thornwood
#> 567                                                                                   Tundra and alpine
#> 568                                                                                            Woodland
#> 569                                                                           azonal (raster value: 95)
#> 570                                                                           azonal (raster value: 96)
#> 571                                                                                              Boreal
#> 572                                                                                   Desert semidesert
#> 573                                                                                   ET Boreal - polar
#> 574                             ET Desert semidesert - tropical subtropical seasonal rainforest savanna
#> 575                                                       ET Desert semidesert - winter cold semidesert
#> 576                                                                ET Laurel forest - desert semidesert
#> 577                                                                    ET Laurel forest - mediterranean
#> 578                                                                          ET Laurel forest - nemoral
#> 579                                                              ET Laurel forest - tropical rainforest
#> 580                                 ET Laurel forest - tropical subtropical seasonal rainforest savanna
#> 581                                                               ET Laurel forest - winter cold steppe
#> 582                                                                ET Mediterranean - desert semidesert
#> 583                                                                          ET Mediterranean - nemoral
#> 584                                                               ET Mediterranean - winter cold steppe
#> 585                                                                                 ET Nemoral - boreal
#> 586                                                                                  ET Nemoral - polar
#> 587                                                                     ET Nemoral - winter cold steppe
#> 588                                                          ET Tropical rainforest - desert semidesert
#> 589                           ET Tropical rainforest - tropical subtropical seasonal rainforest savanna
#> 590                                                                      ET Winter cold steppe - boreal
#> 591                                                                       ET Winter cold steppe - polar
#> 592                               ET Winter cold steppe - tropical subtropical seasonal rainforest sava
#> 593                                                                                       Laurel forest
#> 594                                                                                       Mediterranean
#> 595                                                                                             Nemoral
#> 596                                                                                               Polar
#> 597                                                                                 Tropical rainforest
#> 598                                                    Tropical subtropical seasonal rainforest savanna
#> 599                                                                                  Winter cold desert
#> 600                                                                              Winter cold semidesert
#> 601                                                                                  Winter cold steppe
#> 602                                                                           azonal (raster value: 95)
#> 603                                                                           azonal (raster value: 96)
#>         n
#> 1    2217
#> 2     367
#> 3     384
#> 4     221
#> 5     447
#> 6     583
#> 7     483
#> 8     148
#> 9    5171
#> 10   1687
#> 11    323
#> 12    407
#> 13    729
#> 14   6139
#> 15   1860
#> 16    118
#> 17    824
#> 18      2
#> 19   2342
#> 20    332
#> 21   2301
#> 22      1
#> 23   3049
#> 24   3707
#> 25    190
#> 26     86
#> 27   8829
#> 28   3186
#> 29     67
#> 30     71
#> 31     17
#> 32   2899
#> 33   1092
#> 34      4
#> 35    135
#> 36   1621
#> 37    976
#> 38    854
#> 39    922
#> 40   4523
#> 41    818
#> 42    479
#> 43    175
#> 44   1851
#> 45   6757
#> 46    167
#> 47   1767
#> 48   2153
#> 49    257
#> 50    130
#> 51    779
#> 52   2599
#> 53   2195
#> 54      2
#> 55     85
#> 56     54
#> 57     60
#> 58      9
#> 59      7
#> 60      2
#> 61    402
#> 62     12
#> 63    136
#> 64   1545
#> 65   5090
#> 66    829
#> 67    391
#> 68    152
#> 69     16
#> 70     72
#> 71   1347
#> 72   3873
#> 73    327
#> 74   2380
#> 75    749
#> 76    366
#> 77    387
#> 78    203
#> 79   7760
#> 80   1903
#> 81   1124
#> 82    979
#> 83    143
#> 84    105
#> 85   3621
#> 86    205
#> 87      2
#> 88  10404
#> 89   1818
#> 90   1229
#> 91    170
#> 92    768
#> 93   5155
#> 94   1618
#> 95    602
#> 96      3
#> 97    727
#> 98      2
#> 99      2
#> 100   725
#> 101   681
#> 102   227
#> 103   274
#> 104  2524
#> 105  1145
#> 106 10348
#> 107  1760
#> 108  2518
#> 109  1683
#> 110  2124
#> 111  1736
#> 112   941
#> 113  1198
#> 114   132
#> 115  9429
#> 116   365
#> 117   423
#> 118  2867
#> 119  1800
#> 120  1385
#> 121   403
#> 122     3
#> 123  1046
#> 124   800
#> 125  2002
#> 126   410
#> 127   328
#> 128  9243
#> 129   357
#> 130   463
#> 131  3752
#> 132  1501
#> 133  1803
#> 134  1095
#> 135     2
#> 136     2
#> 137   395
#> 138   714
#> 139   511
#> 140   341
#> 141   369
#> 142   797
#> 143   460
#> 144   272
#> 145  2167
#> 146  6499
#> 147    20
#> 148    28
#> 149  1094
#> 150  3088
#> 151    71
#> 152    77
#> 153    17
#> 154    44
#> 155  1097
#> 156  3877
#> 157  1850
#> 158  5250
#> 159   609
#> 160   252
#> 161   879
#> 162   127
#> 163   131
#> 164    45
#> 165  1292
#> 166   715
#> 167   681
#> 168   621
#> 169     1
#> 170   473
#> 171     1
#> 172    51
#> 173    60
#> 174     3
#> 175   230
#> 176    36
#> 177   343
#> 178    78
#> 179  4724
#> 180   524
#> 181  7623
#> 182    51
#> 183  5174
#> 184   179
#> 185     6
#> 186   150
#> 187    34
#> 188   221
#> 189  3029
#> 190  5150
#> 191     4
#> 192    95
#> 193  2098
#> 194  2533
#> 195  2789
#> 196  8765
#> 197   662
#> 198  4079
#> 199   509
#> 200  1032
#> 201  1348
#> 202     1
#> 203  3438
#> 204  1114
#> 205   767
#> 206  6281
#> 207   238
#> 208   673
#> 209     8
#> 210    32
#> 211  1767
#> 212   457
#> 213   121
#> 214  1812
#> 215  4951
#> 216  4066
#> 217  2314
#> 218  1148
#> 219   774
#> 220     5
#> 221     5
#> 222   494
#> 223  1712
#> 224  1187
#> 225  2392
#> 226  5399
#> 227  1299
#> 228    73
#> 229  3135
#> 230  6210
#> 231   342
#> 232    72
#> 233   707
#> 234   980
#> 235   723
#> 236   973
#> 237   308
#> 238     6
#> 239    68
#> 240    26
#> 241  1979
#> 242  3513
#> 243  6191
#> 244  2647
#> 245  1529
#> 246   906
#> 247    62
#> 248  1326
#> 249   425
#> 250  2226
#> 251    87
#> 252  1373
#> 253    39
#> 254   300
#> 255  2685
#> 256    96
#> 257  2208
#> 258    65
#> 259   384
#> 260  2432
#> 261   147
#> 262   937
#> 263   457
#> 264   812
#> 265  1586
#> 266   833
#> 267 11558
#> 268  3384
#> 269    47
#> 270   545
#> 271   367
#> 272   850
#> 273   296
#> 274  4461
#> 275  1738
#> 276  2988
#> 277  2202
#> 278   290
#> 279  2234
#> 280   383
#> 281   430
#> 282  2944
#> 283  1994
#> 284  2397
#> 285    83
#> 286   108
#> 287   824
#> 288  3786
#> 289   180
#> 290  3348
#> 291   106
#> 292  2031
#> 293   994
#> 294  2608
#> 295    34
#> 296   174
#> 297  1593
#> 298  1232
#> 299  1756
#> 300   905
#> 301  1153
#> 302  2797
#> 303   622
#> 304   604
#> 305    86
#> 306  5620
#> 307     9
#> 308   709
#> 309  1087
#> 310   254
#> 311   184
#> 312  2917
#> 313   594
#> 314   588
#> 315  2760
#> 316  1212
#> 317  7222
#> 318  1907
#> 319   721
#> 320    83
#> 321  4058
#> 322     6
#> 323  2845
#> 324  2595
#> 325  1156
#> 326  1002
#> 327   139
#> 328   100
#> 329  3874
#> 330   230
#> 331     1
#> 332 10595
#> 333  1851
#> 334   805
#> 335   124
#> 336   773
#> 337  5076
#> 338  1683
#> 339   593
#> 340     3
#> 341   425
#> 342   249
#> 343   744
#> 344   702
#> 345   723
#> 346   483
#> 347   151
#> 348  5891
#> 349  7407
#> 350   120
#> 351  1346
#> 352  3127
#> 353   333
#> 354   239
#> 355   582
#> 356  2536
#> 357  1418
#> 358    16
#> 359    65
#> 360    13
#> 361    40
#> 362     9
#> 363     2
#> 364     1
#> 365    86
#> 366  1181
#> 367   366
#> 368   338
#> 369  4749
#> 370  6143
#> 371   820
#> 372   608
#> 373    27
#> 374   167
#> 375  1383
#> 376    86
#> 377     8
#> 378   887
#> 379  2495
#> 380  1005
#> 381  1879
#> 382     2
#> 383  1220
#> 384     1
#> 385  4101
#> 386     8
#> 387    56
#> 388  1623
#> 389   242
#> 390    83
#> 391   368
#> 392  1252
#> 393     1
#> 394   303
#> 395   698
#> 396   260
#> 397  1717
#> 398   289
#> 399     1
#> 400   438
#> 401     1
#> 402    14
#> 403   276
#> 404  1288
#> 405  6308
#> 406   516
#> 407  2389
#> 408  1087
#> 409   400
#> 410  1483
#> 411     5
#> 412   316
#> 413   475
#> 414   438
#> 415  2717
#> 416  1120
#> 417  1007
#> 418   100
#> 419   100
#> 420  3648
#> 421   212
#> 422     2
#> 423 10540
#> 424  1931
#> 425  1166
#> 426   178
#> 427   765
#> 428  4685
#> 429  1697
#> 430   606
#> 431    17
#> 432   213
#> 433   853
#> 434  3290
#> 435  3778
#> 436   611
#> 437     3
#> 438  2579
#> 439  1740
#> 440  5193
#> 441    41
#> 442  2149
#> 443  1057
#> 444   994
#> 445   139
#> 446  3384
#> 447  2060
#> 448  1775
#> 449  2415
#> 450    94
#> 451  1296
#> 452  3187
#> 453   812
#> 454  7265
#> 455  5731
#> 456  3529
#> 457   339
#> 458  2350
#> 459   192
#> 460     4
#> 461     9
#> 462   368
#> 463   959
#> 464  1208
#> 465    15
#> 466   446
#> 467  7450
#> 468   373
#> 469   932
#> 470  1339
#> 471     1
#> 472   228
#> 473     1
#> 474     8
#> 475   542
#> 476   157
#> 477    37
#> 478   341
#> 479  1919
#> 480  1219
#> 481    11
#> 482   449
#> 483   109
#> 484     6
#> 485   906
#> 486   363
#> 487     5
#> 488    94
#> 489    26
#> 490    10
#> 491   200
#> 492  3055
#> 493   533
#> 494   898
#> 495    23
#> 496    95
#> 497   605
#> 498  2118
#> 499   842
#> 500   752
#> 501 11073
#> 502   530
#> 503  4541
#> 504    16
#> 505   203
#> 506   321
#> 507     8
#> 508   253
#> 509  4161
#> 510    39
#> 511   237
#> 512  2644
#> 513   574
#> 514   258
#> 515  1925
#> 516  1885
#> 517   509
#> 518    28
#> 519  4059
#> 520   731
#> 521 14346
#> 522  1441
#> 523     8
#> 524  1501
#> 525   730
#> 526   118
#> 527   230
#> 528   133
#> 529    92
#> 530   226
#> 531   398
#> 532  1291
#> 533  1255
#> 534   591
#> 535   454
#> 536   150
#> 537    51
#> 538  4893
#> 539   128
#> 540     1
#> 541   249
#> 542    29
#> 543  9241
#> 544   740
#> 545   168
#> 546   570
#> 547    24
#> 548  4368
#> 549   406
#> 550   157
#> 551   768
#> 552   871
#> 553   377
#> 554   419
#> 555    22
#> 556    41
#> 557   230
#> 558  1197
#> 559  4884
#> 560  4282
#> 561 13310
#> 562   527
#> 563   731
#> 564   846
#> 565   443
#> 566   417
#> 567  1210
#> 568   236
#> 569    23
#> 570   237
#> 571   594
#> 572   249
#> 573   652
#> 574  4424
#> 575     7
#> 576   116
#> 577   891
#> 578  1623
#> 579     6
#> 580   289
#> 581   368
#> 582   741
#> 583    66
#> 584    34
#> 585   979
#> 586     8
#> 587    54
#> 588    32
#> 589   699
#> 590    12
#> 591   112
#> 592    17
#> 593  2870
#> 594  3347
#> 595  6172
#> 596    14
#> 597  1490
#> 598  1574
#> 599    62
#> 600   160
#> 601   396
#> 602    48
#> 603   237

# Tabulate by raster value
classified_ids <- biomes_classify(
  x     = biomes_example,
  value = "ID"
)
#> no biome file or layer provided using default biomes
#> Warning: Coordinates provided as data.frame, assuming WGS84 as CRS
#> Warning: [extract] transforming vector data to the CRS of the raster
#> Classified 29104 record(s) against 31 biome layer(s):
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
biomes_biome_tab(classified_ids, value = "ID")
#>                        layer biome     n
#> 1   Biome_Inventory_layer_01     1  1860
#> 2   Biome_Inventory_layer_01     2   824
#> 3   Biome_Inventory_layer_01     3   447
#> 4   Biome_Inventory_layer_01     4   118
#> 5   Biome_Inventory_layer_01     5  2342
#> 6   Biome_Inventory_layer_01     6   221
#> 7   Biome_Inventory_layer_01     7  5171
#> 8   Biome_Inventory_layer_01     8   583
#> 9   Biome_Inventory_layer_01     9   729
#> 10  Biome_Inventory_layer_01    10   323
#> 11  Biome_Inventory_layer_01    11   148
#> 12  Biome_Inventory_layer_01    12   407
#> 13  Biome_Inventory_layer_01    13  6139
#> 14  Biome_Inventory_layer_01    14  1687
#> 15  Biome_Inventory_layer_01    15   367
#> 16  Biome_Inventory_layer_01    16     2
#> 17  Biome_Inventory_layer_01    17   384
#> 18  Biome_Inventory_layer_01    18  2217
#> 19  Biome_Inventory_layer_01    20   483
#> 20  Biome_Inventory_layer_02     1  3049
#> 21  Biome_Inventory_layer_02     2    71
#> 22  Biome_Inventory_layer_02     3  2899
#> 23  Biome_Inventory_layer_02     4  1092
#> 24  Biome_Inventory_layer_02     5   332
#> 25  Biome_Inventory_layer_02     6  8829
#> 26  Biome_Inventory_layer_02     7  2301
#> 27  Biome_Inventory_layer_02     8    86
#> 28  Biome_Inventory_layer_02    10  3186
#> 29  Biome_Inventory_layer_02    11    17
#> 30  Biome_Inventory_layer_02    12   190
#> 31  Biome_Inventory_layer_02    13  3707
#> 32  Biome_Inventory_layer_02    14    67
#> 33  Biome_Inventory_layer_02    15     1
#> 34  Biome_Inventory_layer_02    17     4
#> 35  Biome_Inventory_layer_02    95   135
#> 36  Biome_Inventory_layer_02    98  1621
#> 37  Biome_Inventory_layer_03     1   976
#> 38  Biome_Inventory_layer_03     2   854
#> 39  Biome_Inventory_layer_03     3   922
#> 40  Biome_Inventory_layer_03     5  4523
#> 41  Biome_Inventory_layer_03     6   130
#> 42  Biome_Inventory_layer_03     7   257
#> 43  Biome_Inventory_layer_03     8   479
#> 44  Biome_Inventory_layer_03     9  1851
#> 45  Biome_Inventory_layer_03    10  2153
#> 46  Biome_Inventory_layer_03    11     2
#> 47  Biome_Inventory_layer_03    13  6757
#> 48  Biome_Inventory_layer_03    14  1767
#> 49  Biome_Inventory_layer_03    15   175
#> 50  Biome_Inventory_layer_03    16    85
#> 51  Biome_Inventory_layer_03    17   818
#> 52  Biome_Inventory_layer_03    18    60
#> 53  Biome_Inventory_layer_03    19   779
#> 54  Biome_Inventory_layer_03    20     9
#> 55  Biome_Inventory_layer_03    21   167
#> 56  Biome_Inventory_layer_03    22  2599
#> 57  Biome_Inventory_layer_03    23     7
#> 58  Biome_Inventory_layer_03    24   402
#> 59  Biome_Inventory_layer_03    25  2195
#> 60  Biome_Inventory_layer_03    26    54
#> 61  Biome_Inventory_layer_03    30     2
#> 62  Biome_Inventory_layer_04     1   366
#> 63  Biome_Inventory_layer_04     2   203
#> 64  Biome_Inventory_layer_04     3   387
#> 65  Biome_Inventory_layer_04     4   749
#> 66  Biome_Inventory_layer_04     5  1903
#> 67  Biome_Inventory_layer_04     6  7760
#> 68  Biome_Inventory_layer_04     7  1347
#> 69  Biome_Inventory_layer_04     8  2380
#> 70  Biome_Inventory_layer_04     9   391
#> 71  Biome_Inventory_layer_04    10   327
#> 72  Biome_Inventory_layer_04    11  3873
#> 73  Biome_Inventory_layer_04    12   829
#> 74  Biome_Inventory_layer_04    13  5090
#> 75  Biome_Inventory_layer_04    14    16
#> 76  Biome_Inventory_layer_04    15   136
#> 77  Biome_Inventory_layer_04    16  1545
#> 78  Biome_Inventory_layer_04    17    12
#> 79  Biome_Inventory_layer_04    18    72
#> 80  Biome_Inventory_layer_04    19   152
#> 81  Biome_Inventory_layer_05     1  1618
#> 82  Biome_Inventory_layer_05     2   105
#> 83  Biome_Inventory_layer_05     3  5155
#> 84  Biome_Inventory_layer_05     4   768
#> 85  Biome_Inventory_layer_05     5   143
#> 86  Biome_Inventory_layer_05     6   170
#> 87  Biome_Inventory_layer_05     7   979
#> 88  Biome_Inventory_layer_05     8   205
#> 89  Biome_Inventory_layer_05     9  3621
#> 90  Biome_Inventory_layer_05    10  1229
#> 91  Biome_Inventory_layer_05    11 10404
#> 92  Biome_Inventory_layer_05    12  1818
#> 93  Biome_Inventory_layer_05    13  1124
#> 94  Biome_Inventory_layer_05    14   602
#> 95  Biome_Inventory_layer_05    15     2
#> 96  Biome_Inventory_layer_06     1  1760
#> 97  Biome_Inventory_layer_06     2  1683
#> 98  Biome_Inventory_layer_06     3  2518
#> 99  Biome_Inventory_layer_06     4  1145
#> 100 Biome_Inventory_layer_06     5   227
#> 101 Biome_Inventory_layer_06     6 10348
#> 102 Biome_Inventory_layer_06     7   274
#> 103 Biome_Inventory_layer_06     8   681
#> 104 Biome_Inventory_layer_06     9  2524
#> 105 Biome_Inventory_layer_06    10   725
#> 106 Biome_Inventory_layer_06    11   727
#> 107 Biome_Inventory_layer_06    12     3
#> 108 Biome_Inventory_layer_06    13     2
#> 109 Biome_Inventory_layer_06    14     2
#> 110 Biome_Inventory_layer_07     1   423
#> 111 Biome_Inventory_layer_07     2   403
#> 112 Biome_Inventory_layer_07     3  1800
#> 113 Biome_Inventory_layer_07     4  1736
#> 114 Biome_Inventory_layer_07     5  2124
#> 115 Biome_Inventory_layer_07     6   941
#> 116 Biome_Inventory_layer_07     7  1198
#> 117 Biome_Inventory_layer_07     8  2867
#> 118 Biome_Inventory_layer_07     9  1385
#> 119 Biome_Inventory_layer_07    10   365
#> 120 Biome_Inventory_layer_07    11  9429
#> 121 Biome_Inventory_layer_07    12   132
#> 122 Biome_Inventory_layer_08     1   463
#> 123 Biome_Inventory_layer_08     2  1501
#> 124 Biome_Inventory_layer_08     3  1095
#> 125 Biome_Inventory_layer_08     4  1046
#> 126 Biome_Inventory_layer_08     5   410
#> 127 Biome_Inventory_layer_08     6   800
#> 128 Biome_Inventory_layer_08     7  2002
#> 129 Biome_Inventory_layer_08     8  3752
#> 130 Biome_Inventory_layer_08     9  1803
#> 131 Biome_Inventory_layer_08    10   357
#> 132 Biome_Inventory_layer_08    11  9243
#> 133 Biome_Inventory_layer_08    12   328
#> 134 Biome_Inventory_layer_08    13     3
#> 135 Biome_Inventory_layer_09     1  3088
#> 136 Biome_Inventory_layer_09     2  1094
#> 137 Biome_Inventory_layer_09     3   395
#> 138 Biome_Inventory_layer_09     4   714
#> 139 Biome_Inventory_layer_09     5  2167
#> 140 Biome_Inventory_layer_09     6  1850
#> 141 Biome_Inventory_layer_09     7   369
#> 142 Biome_Inventory_layer_09     8   797
#> 143 Biome_Inventory_layer_09     9    20
#> 144 Biome_Inventory_layer_09    10    17
#> 145 Biome_Inventory_layer_09    11     2
#> 146 Biome_Inventory_layer_09    12    44
#> 147 Biome_Inventory_layer_09    13  6499
#> 148 Biome_Inventory_layer_09    14  5250
#> 149 Biome_Inventory_layer_09    15     2
#> 150 Biome_Inventory_layer_09    16    28
#> 151 Biome_Inventory_layer_09    17   460
#> 152 Biome_Inventory_layer_09    18  1097
#> 153 Biome_Inventory_layer_09    19   511
#> 154 Biome_Inventory_layer_09    20   272
#> 155 Biome_Inventory_layer_09    21  3877
#> 156 Biome_Inventory_layer_09    22   341
#> 157 Biome_Inventory_layer_09    23    71
#> 158 Biome_Inventory_layer_09    24    77
#> 159 Biome_Inventory_layer_10     1   609
#> 160 Biome_Inventory_layer_10     2    36
#> 161 Biome_Inventory_layer_10     3   131
#> 162 Biome_Inventory_layer_10     4   230
#> 163 Biome_Inventory_layer_10     5   343
#> 164 Biome_Inventory_layer_10     6  5174
#> 165 Biome_Inventory_layer_10     7   127
#> 166 Biome_Inventory_layer_10     8   179
#> 167 Biome_Inventory_layer_10     9     6
#> 168 Biome_Inventory_layer_10    10    51
#> 169 Biome_Inventory_layer_10    11   681
#> 170 Biome_Inventory_layer_10    12   150
#> 171 Biome_Inventory_layer_10    13     1
#> 172 Biome_Inventory_layer_10    14    78
#> 173 Biome_Inventory_layer_10    15  4724
#> 174 Biome_Inventory_layer_10    16    51
#> 175 Biome_Inventory_layer_10    17     1
#> 176 Biome_Inventory_layer_10    18    60
#> 177 Biome_Inventory_layer_10    19   715
#> 178 Biome_Inventory_layer_10    20  7623
#> 179 Biome_Inventory_layer_10    21   473
#> 180 Biome_Inventory_layer_10    22   252
#> 181 Biome_Inventory_layer_10    23    45
#> 182 Biome_Inventory_layer_10    24  1292
#> 183 Biome_Inventory_layer_10    25   621
#> 184 Biome_Inventory_layer_10    26   879
#> 185 Biome_Inventory_layer_10    28   524
#> 186 Biome_Inventory_layer_10    29     3
#> 187 Biome_Inventory_layer_10    95    34
#> 188 Biome_Inventory_layer_10    96   221
#> 189 Biome_Inventory_layer_10    97  3029
#> 190 Biome_Inventory_layer_11     1   509
#> 191 Biome_Inventory_layer_11     2  1348
#> 192 Biome_Inventory_layer_11     3  1032
#> 193 Biome_Inventory_layer_11     4   662
#> 194 Biome_Inventory_layer_11     5  4079
#> 195 Biome_Inventory_layer_11     6  2789
#> 196 Biome_Inventory_layer_11     7  5150
#> 197 Biome_Inventory_layer_11     8  2533
#> 198 Biome_Inventory_layer_11     9  8765
#> 199 Biome_Inventory_layer_11    10  2098
#> 200 Biome_Inventory_layer_11    11    95
#> 201 Biome_Inventory_layer_11    13     4
#> 202 Biome_Inventory_layer_12     1  1767
#> 203 Biome_Inventory_layer_12     2  4951
#> 204 Biome_Inventory_layer_12     3   457
#> 205 Biome_Inventory_layer_12     4    32
#> 206 Biome_Inventory_layer_12     5  1812
#> 207 Biome_Inventory_layer_12     6   121
#> 208 Biome_Inventory_layer_12     7  2314
#> 209 Biome_Inventory_layer_12     8  4066
#> 210 Biome_Inventory_layer_12     9  6281
#> 211 Biome_Inventory_layer_12    10   238
#> 212 Biome_Inventory_layer_12    11   767
#> 213 Biome_Inventory_layer_12    12  3438
#> 214 Biome_Inventory_layer_12    13  1114
#> 215 Biome_Inventory_layer_12    14   673
#> 216 Biome_Inventory_layer_12    15     8
#> 217 Biome_Inventory_layer_12    16     1
#> 218 Biome_Inventory_layer_13     1   973
#> 219 Biome_Inventory_layer_13     2   980
#> 220 Biome_Inventory_layer_13     3   723
#> 221 Biome_Inventory_layer_13     4   308
#> 222 Biome_Inventory_layer_13     5   707
#> 223 Biome_Inventory_layer_13     6    72
#> 224 Biome_Inventory_layer_13     7   494
#> 225 Biome_Inventory_layer_13     8  1187
#> 226 Biome_Inventory_layer_13     9  2392
#> 227 Biome_Inventory_layer_13    10  5399
#> 228 Biome_Inventory_layer_13    11  1712
#> 229 Biome_Inventory_layer_13    12  3135
#> 230 Biome_Inventory_layer_13    13    73
#> 231 Biome_Inventory_layer_13    14   342
#> 232 Biome_Inventory_layer_13    15  1299
#> 233 Biome_Inventory_layer_13    16  6210
#> 234 Biome_Inventory_layer_13    17   774
#> 235 Biome_Inventory_layer_13    18  1148
#> 236 Biome_Inventory_layer_13    19     5
#> 237 Biome_Inventory_layer_13    20     5
#> 238 Biome_Inventory_layer_13    95     6
#> 239 Biome_Inventory_layer_14     1    62
#> 240 Biome_Inventory_layer_14     2  3513
#> 241 Biome_Inventory_layer_14     3   906
#> 242 Biome_Inventory_layer_14     4    26
#> 243 Biome_Inventory_layer_14     5    87
#> 244 Biome_Inventory_layer_14     6  2647
#> 245 Biome_Inventory_layer_14     7  1373
#> 246 Biome_Inventory_layer_14     8  1979
#> 247 Biome_Inventory_layer_14     9    68
#> 248 Biome_Inventory_layer_14    10  2685
#> 249 Biome_Inventory_layer_14    11    96
#> 250 Biome_Inventory_layer_14    12   300
#> 251 Biome_Inventory_layer_14    13  6191
#> 252 Biome_Inventory_layer_14    14  1529
#> 253 Biome_Inventory_layer_14    15  2226
#> 254 Biome_Inventory_layer_14    16  1326
#> 255 Biome_Inventory_layer_14    17   425
#> 256 Biome_Inventory_layer_14    18    39
#> 257 Biome_Inventory_layer_14    98  2208
#> 258 Biome_Inventory_layer_15     1   937
#> 259 Biome_Inventory_layer_15     2 11558
#> 260 Biome_Inventory_layer_15     3  3384
#> 261 Biome_Inventory_layer_15     4   147
#> 262 Biome_Inventory_layer_15     5   812
#> 263 Biome_Inventory_layer_15     6  2432
#> 264 Biome_Inventory_layer_15     7   833
#> 265 Biome_Inventory_layer_15     8   384
#> 266 Biome_Inventory_layer_15     9    65
#> 267 Biome_Inventory_layer_15    10  1586
#> 268 Biome_Inventory_layer_15    11   457
#> 269 Biome_Inventory_layer_15    98    47
#> 270 Biome_Inventory_layer_16     1  1994
#> 271 Biome_Inventory_layer_16     2   296
#> 272 Biome_Inventory_layer_16     3  2397
#> 273 Biome_Inventory_layer_16     4    83
#> 274 Biome_Inventory_layer_16     5  1738
#> 275 Biome_Inventory_layer_16     6   383
#> 276 Biome_Inventory_layer_16     7  2988
#> 277 Biome_Inventory_layer_16     8  2202
#> 278 Biome_Inventory_layer_16     9   850
#> 279 Biome_Inventory_layer_16    10   545
#> 280 Biome_Inventory_layer_16    11  2234
#> 281 Biome_Inventory_layer_16    12   367
#> 282 Biome_Inventory_layer_16    13  2944
#> 283 Biome_Inventory_layer_16    14   430
#> 284 Biome_Inventory_layer_16    15  4461
#> 285 Biome_Inventory_layer_16    16   290
#> 286 Biome_Inventory_layer_16    17   108
#> 287 Biome_Inventory_layer_16    18   824
#> 288 Biome_Inventory_layer_16    98  3786
#> 289 Biome_Inventory_layer_17     1    34
#> 290 Biome_Inventory_layer_17     2  2608
#> 291 Biome_Inventory_layer_17     3   622
#> 292 Biome_Inventory_layer_17     4   106
#> 293 Biome_Inventory_layer_17     5   994
#> 294 Biome_Inventory_layer_17     6  2797
#> 295 Biome_Inventory_layer_17     7  1756
#> 296 Biome_Inventory_layer_17     8    86
#> 297 Biome_Inventory_layer_17     9  1593
#> 298 Biome_Inventory_layer_17    10   180
#> 299 Biome_Inventory_layer_17    11  5620
#> 300 Biome_Inventory_layer_17    12   905
#> 301 Biome_Inventory_layer_17    13  3348
#> 302 Biome_Inventory_layer_17    14  2031
#> 303 Biome_Inventory_layer_17    15  1153
#> 304 Biome_Inventory_layer_17    16   174
#> 305 Biome_Inventory_layer_17    17   709
#> 306 Biome_Inventory_layer_17    18  1232
#> 307 Biome_Inventory_layer_17    19   604
#> 308 Biome_Inventory_layer_17    20     9
#> 309 Biome_Inventory_layer_17    98  1087
#> 310 Biome_Inventory_layer_18     1  2760
#> 311 Biome_Inventory_layer_18     2   594
#> 312 Biome_Inventory_layer_18     3   184
#> 313 Biome_Inventory_layer_18     4   254
#> 314 Biome_Inventory_layer_18     5  4058
#> 315 Biome_Inventory_layer_18     6  7222
#> 316 Biome_Inventory_layer_18     7  2917
#> 317 Biome_Inventory_layer_18     8   588
#> 318 Biome_Inventory_layer_18     9  2845
#> 319 Biome_Inventory_layer_18    10   721
#> 320 Biome_Inventory_layer_18    11    83
#> 321 Biome_Inventory_layer_18    12  1907
#> 322 Biome_Inventory_layer_18    13  1212
#> 323 Biome_Inventory_layer_18    15     6
#> 324 Biome_Inventory_layer_18    98  2595
#> 325 Biome_Inventory_layer_19     1  1683
#> 326 Biome_Inventory_layer_19     2   100
#> 327 Biome_Inventory_layer_19     3  5076
#> 328 Biome_Inventory_layer_19     4   773
#> 329 Biome_Inventory_layer_19     5   124
#> 330 Biome_Inventory_layer_19     6   139
#> 331 Biome_Inventory_layer_19     7  1002
#> 332 Biome_Inventory_layer_19     8   230
#> 333 Biome_Inventory_layer_19     9  3874
#> 334 Biome_Inventory_layer_19    10 10595
#> 335 Biome_Inventory_layer_19    11   805
#> 336 Biome_Inventory_layer_19    12  1851
#> 337 Biome_Inventory_layer_19    13  1156
#> 338 Biome_Inventory_layer_19    14   593
#> 339 Biome_Inventory_layer_19    15     1
#> 340 Biome_Inventory_layer_19    95     3
#> 341 Biome_Inventory_layer_20     1   425
#> 342 Biome_Inventory_layer_20     2   249
#> 343 Biome_Inventory_layer_20     3   744
#> 344 Biome_Inventory_layer_20     5   702
#> 345 Biome_Inventory_layer_20     6   239
#> 346 Biome_Inventory_layer_20     7   333
#> 347 Biome_Inventory_layer_20     8   483
#> 348 Biome_Inventory_layer_20     9  5891
#> 349 Biome_Inventory_layer_20    10  3127
#> 350 Biome_Inventory_layer_20    11  1346
#> 351 Biome_Inventory_layer_20    12   366
#> 352 Biome_Inventory_layer_20    13   151
#> 353 Biome_Inventory_layer_20    14  7407
#> 354 Biome_Inventory_layer_20    15   723
#> 355 Biome_Inventory_layer_20    16    16
#> 356 Biome_Inventory_layer_20    17    40
#> 357 Biome_Inventory_layer_20    18     9
#> 358 Biome_Inventory_layer_20    19   582
#> 359 Biome_Inventory_layer_20    20    65
#> 360 Biome_Inventory_layer_20    21    86
#> 361 Biome_Inventory_layer_20    22   120
#> 362 Biome_Inventory_layer_20    23     2
#> 363 Biome_Inventory_layer_20    24  2536
#> 364 Biome_Inventory_layer_20    25    13
#> 365 Biome_Inventory_layer_20    26  1418
#> 366 Biome_Inventory_layer_20    30  1181
#> 367 Biome_Inventory_layer_20    31     1
#> 368 Biome_Inventory_layer_21     1     8
#> 369 Biome_Inventory_layer_21     2  1879
#> 370 Biome_Inventory_layer_21     3    56
#> 371 Biome_Inventory_layer_21     4  1005
#> 372 Biome_Inventory_layer_21     5   608
#> 373 Biome_Inventory_layer_21     6   820
#> 374 Biome_Inventory_layer_21     7   338
#> 375 Biome_Inventory_layer_21     8  6143
#> 376 Biome_Inventory_layer_21     9  1383
#> 377 Biome_Inventory_layer_21    10  4749
#> 378 Biome_Inventory_layer_21    11  2495
#> 379 Biome_Inventory_layer_21    12    86
#> 380 Biome_Inventory_layer_21    13   887
#> 381 Biome_Inventory_layer_21    14    27
#> 382 Biome_Inventory_layer_21    15   167
#> 383 Biome_Inventory_layer_21    16  4101
#> 384 Biome_Inventory_layer_21    17  1220
#> 385 Biome_Inventory_layer_21    18     2
#> 386 Biome_Inventory_layer_21    19     1
#> 387 Biome_Inventory_layer_21    20     8
#> 388 Biome_Inventory_layer_21    98  1623
#> 389 Biome_Inventory_layer_22     1  1483
#> 390 Biome_Inventory_layer_22     2   475
#> 391 Biome_Inventory_layer_22     3   316
#> 392 Biome_Inventory_layer_22     4   400
#> 393 Biome_Inventory_layer_22     5   438
#> 394 Biome_Inventory_layer_22     6     5
#> 395 Biome_Inventory_layer_22     7   242
#> 396 Biome_Inventory_layer_22     8   698
#> 397 Biome_Inventory_layer_22     9  2717
#> 398 Biome_Inventory_layer_22    10  1288
#> 399 Biome_Inventory_layer_22    11  2389
#> 400 Biome_Inventory_layer_22    12   289
#> 401 Biome_Inventory_layer_22    13  1087
#> 402 Biome_Inventory_layer_22    14    14
#> 403 Biome_Inventory_layer_22    15   276
#> 404 Biome_Inventory_layer_22    16  6308
#> 405 Biome_Inventory_layer_22    17   516
#> 406 Biome_Inventory_layer_22    18    83
#> 407 Biome_Inventory_layer_22    19  1252
#> 408 Biome_Inventory_layer_22    20   368
#> 409 Biome_Inventory_layer_22    21  1717
#> 410 Biome_Inventory_layer_22    22   303
#> 411 Biome_Inventory_layer_22    23     1
#> 412 Biome_Inventory_layer_22    24   438
#> 413 Biome_Inventory_layer_22    25   260
#> 414 Biome_Inventory_layer_22    26     1
#> 415 Biome_Inventory_layer_22    27     1
#> 416 Biome_Inventory_layer_23     1  1697
#> 417 Biome_Inventory_layer_23     2   100
#> 418 Biome_Inventory_layer_23     3  4685
#> 419 Biome_Inventory_layer_23     4   765
#> 420 Biome_Inventory_layer_23     5   178
#> 421 Biome_Inventory_layer_23     6   100
#> 422 Biome_Inventory_layer_23     7  1007
#> 423 Biome_Inventory_layer_23     8   212
#> 424 Biome_Inventory_layer_23     9  3648
#> 425 Biome_Inventory_layer_23    10 10540
#> 426 Biome_Inventory_layer_23    11  1931
#> 427 Biome_Inventory_layer_23    12  1166
#> 428 Biome_Inventory_layer_23    13  1120
#> 429 Biome_Inventory_layer_23    14   606
#> 430 Biome_Inventory_layer_23    15     2
#> 431 Biome_Inventory_layer_23    95    17
#> 432 Biome_Inventory_layer_24     1  2579
#> 433 Biome_Inventory_layer_24     2   994
#> 434 Biome_Inventory_layer_24     3  3290
#> 435 Biome_Inventory_layer_24     4   213
#> 436 Biome_Inventory_layer_24     5  3384
#> 437 Biome_Inventory_layer_24     6   611
#> 438 Biome_Inventory_layer_24     7   139
#> 439 Biome_Inventory_layer_24     8   853
#> 440 Biome_Inventory_layer_24     9  5193
#> 441 Biome_Inventory_layer_24    10  3778
#> 442 Biome_Inventory_layer_24    11  1057
#> 443 Biome_Inventory_layer_24    12  2149
#> 444 Biome_Inventory_layer_24    13  1740
#> 445 Biome_Inventory_layer_24    14     3
#> 446 Biome_Inventory_layer_24    15    41
#> 447 Biome_Inventory_layer_24    98  2060
#> 448 Biome_Inventory_layer_25     1  2350
#> 449 Biome_Inventory_layer_25     2   339
#> 450 Biome_Inventory_layer_25     3  7265
#> 451 Biome_Inventory_layer_25     4  2415
#> 452 Biome_Inventory_layer_25     5    94
#> 453 Biome_Inventory_layer_25     6   812
#> 454 Biome_Inventory_layer_25     7  1296
#> 455 Biome_Inventory_layer_25     8  3529
#> 456 Biome_Inventory_layer_25     9  5731
#> 457 Biome_Inventory_layer_25    10  3187
#> 458 Biome_Inventory_layer_25    11   192
#> 459 Biome_Inventory_layer_25    12  1775
#> 460 Biome_Inventory_layer_26     1   363
#> 461 Biome_Inventory_layer_26     2   109
#> 462 Biome_Inventory_layer_26     4    26
#> 463 Biome_Inventory_layer_26     5    11
#> 464 Biome_Inventory_layer_26     6   906
#> 465 Biome_Inventory_layer_26     7  1219
#> 466 Biome_Inventory_layer_26     8    94
#> 467 Biome_Inventory_layer_26     9     5
#> 468 Biome_Inventory_layer_26    10  1919
#> 469 Biome_Inventory_layer_26    12    23
#> 470 Biome_Inventory_layer_26    13     6
#> 471 Biome_Inventory_layer_26    14   449
#> 472 Biome_Inventory_layer_26    15    37
#> 473 Biome_Inventory_layer_26    16   341
#> 474 Biome_Inventory_layer_26    17   533
#> 475 Biome_Inventory_layer_26    18    10
#> 476 Biome_Inventory_layer_26    19  3055
#> 477 Biome_Inventory_layer_26    20   373
#> 478 Biome_Inventory_layer_26    21   898
#> 479 Biome_Inventory_layer_26    22   200
#> 480 Biome_Inventory_layer_26    23  1339
#> 481 Biome_Inventory_layer_26    24    15
#> 482 Biome_Inventory_layer_26    25   446
#> 483 Biome_Inventory_layer_26    26   932
#> 484 Biome_Inventory_layer_26    27   959
#> 485 Biome_Inventory_layer_26    28  7450
#> 486 Biome_Inventory_layer_26    29     4
#> 487 Biome_Inventory_layer_26    30     9
#> 488 Biome_Inventory_layer_26    31   542
#> 489 Biome_Inventory_layer_26    32  1208
#> 490 Biome_Inventory_layer_26    33   368
#> 491 Biome_Inventory_layer_26    34   228
#> 492 Biome_Inventory_layer_26    35     1
#> 493 Biome_Inventory_layer_26    36   157
#> 494 Biome_Inventory_layer_26    37     8
#> 495 Biome_Inventory_layer_26    38     1
#> 496 Biome_Inventory_layer_26    95    95
#> 497 Biome_Inventory_layer_27     1   842
#> 498 Biome_Inventory_layer_27     2   530
#> 499 Biome_Inventory_layer_27     3   752
#> 500 Biome_Inventory_layer_27     4  4541
#> 501 Biome_Inventory_layer_27     5   321
#> 502 Biome_Inventory_layer_27     6  2118
#> 503 Biome_Inventory_layer_27     7   253
#> 504 Biome_Inventory_layer_27     8  4161
#> 505 Biome_Inventory_layer_27     9    16
#> 506 Biome_Inventory_layer_27    10   203
#> 507 Biome_Inventory_layer_27    11 11073
#> 508 Biome_Inventory_layer_27    12   605
#> 509 Biome_Inventory_layer_27    13     8
#> 510 Biome_Inventory_layer_27    95    39
#> 511 Biome_Inventory_layer_27    96   237
#> 512 Biome_Inventory_layer_27    97  2644
#> 513 Biome_Inventory_layer_28     1  1501
#> 514 Biome_Inventory_layer_28     2     8
#> 515 Biome_Inventory_layer_28     3   509
#> 516 Biome_Inventory_layer_28     4   258
#> 517 Biome_Inventory_layer_28     5  1441
#> 518 Biome_Inventory_layer_28     6   574
#> 519 Biome_Inventory_layer_28     7  1885
#> 520 Biome_Inventory_layer_28     8  1925
#> 521 Biome_Inventory_layer_28     9 14346
#> 522 Biome_Inventory_layer_28    10   731
#> 523 Biome_Inventory_layer_28    11  4059
#> 524 Biome_Inventory_layer_28    12   730
#> 525 Biome_Inventory_layer_28    13    28
#> 526 Biome_Inventory_layer_28    95   118
#> 527 Biome_Inventory_layer_28    96   230
#> 528 Biome_Inventory_layer_29     1   377
#> 529 Biome_Inventory_layer_29     2    51
#> 530 Biome_Inventory_layer_29     3   591
#> 531 Biome_Inventory_layer_29     4   871
#> 532 Biome_Inventory_layer_29     5   419
#> 533 Biome_Inventory_layer_29     6   226
#> 534 Biome_Inventory_layer_29     7    24
#> 535 Biome_Inventory_layer_29     8  4368
#> 536 Biome_Inventory_layer_29     9   768
#> 537 Biome_Inventory_layer_29    10    92
#> 538 Biome_Inventory_layer_29    11  1255
#> 539 Biome_Inventory_layer_29    12   128
#> 540 Biome_Inventory_layer_29    13   406
#> 541 Biome_Inventory_layer_29    14  4893
#> 542 Biome_Inventory_layer_29    15   133
#> 543 Biome_Inventory_layer_29    16   398
#> 544 Biome_Inventory_layer_29    17   157
#> 545 Biome_Inventory_layer_29    18  9241
#> 546 Biome_Inventory_layer_29    19   150
#> 547 Biome_Inventory_layer_29    20     1
#> 548 Biome_Inventory_layer_29    21   168
#> 549 Biome_Inventory_layer_29    22   740
#> 550 Biome_Inventory_layer_29    23   454
#> 551 Biome_Inventory_layer_29    24   570
#> 552 Biome_Inventory_layer_29    25  1291
#> 553 Biome_Inventory_layer_29    26    29
#> 554 Biome_Inventory_layer_29    27   249
#> 555 Biome_Inventory_layer_29    28    22
#> 556 Biome_Inventory_layer_29    95    41
#> 557 Biome_Inventory_layer_29    96   230
#> 558 Biome_Inventory_layer_30     1   731
#> 559 Biome_Inventory_layer_30     2   846
#> 560 Biome_Inventory_layer_30     3   417
#> 561 Biome_Inventory_layer_30     4   443
#> 562 Biome_Inventory_layer_30     5   236
#> 563 Biome_Inventory_layer_30     6  4884
#> 564 Biome_Inventory_layer_30     7  4282
#> 565 Biome_Inventory_layer_30     8 13310
#> 566 Biome_Inventory_layer_30     9   527
#> 567 Biome_Inventory_layer_30    10  1197
#> 568 Biome_Inventory_layer_30    11  1210
#> 569 Biome_Inventory_layer_30    95    23
#> 570 Biome_Inventory_layer_30    96   237
#> 571 Biome_Inventory_layer_31     1    32
#> 572 Biome_Inventory_layer_31     2  1490
#> 573 Biome_Inventory_layer_31     3   699
#> 574 Biome_Inventory_layer_31     4  1574
#> 575 Biome_Inventory_layer_31     5  4424
#> 576 Biome_Inventory_layer_31     6   249
#> 577 Biome_Inventory_layer_31     7   289
#> 578 Biome_Inventory_layer_31     8     6
#> 579 Biome_Inventory_layer_31     9   116
#> 580 Biome_Inventory_layer_31    10   741
#> 581 Biome_Inventory_layer_31    11    17
#> 582 Biome_Inventory_layer_31    12  2870
#> 583 Biome_Inventory_layer_31    13   368
#> 584 Biome_Inventory_layer_31    14     7
#> 585 Biome_Inventory_layer_31    15    34
#> 586 Biome_Inventory_layer_31    16  3347
#> 587 Biome_Inventory_layer_31    17    62
#> 588 Biome_Inventory_layer_31    18   891
#> 589 Biome_Inventory_layer_31    19   396
#> 590 Biome_Inventory_layer_31    20   160
#> 591 Biome_Inventory_layer_31    21    66
#> 592 Biome_Inventory_layer_31    22  6172
#> 593 Biome_Inventory_layer_31    23  1623
#> 594 Biome_Inventory_layer_31    24   112
#> 595 Biome_Inventory_layer_31    25    54
#> 596 Biome_Inventory_layer_31    26   979
#> 597 Biome_Inventory_layer_31    27     8
#> 598 Biome_Inventory_layer_31    28   594
#> 599 Biome_Inventory_layer_31    29    12
#> 600 Biome_Inventory_layer_31    30   652
#> 601 Biome_Inventory_layer_31    31    14
#> 602 Biome_Inventory_layer_31    95    48
#> 603 Biome_Inventory_layer_31    96   237
```
