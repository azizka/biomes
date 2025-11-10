## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Test environments
- R version 4.2.2 (2022-10-31 ucrt)
- Windows 10 x64

## NOTE about package size
* Installed size is 35.9 MB.
  - This is expected. The core functionality requires including a global biome raster data stack.
  - All large files are essential. The raster allows users to perform reproducible, offline analyses out-of-the-box.
  - The package dynamically generates polygons and extracts data subsets in memory as required, minimizing runtime load.
  - Further reduction is not feasible without losing core features.
