
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qubitr

Analyse results from the Clariostar Qubit assay

## Installation

You can use `devtools` to install qubitr from GitHub:

``` r
install.packages("devtools")
devtools::install_github("TomHarrop/qubitr")
```

## Example

Run the analysis:

``` r
library(data.table)
library(qubitr)
```

#### Load the raw data

  - You’ll need columns called `plate_row`, `plate_col` and `raw_fl` for
    the analysis. `content` helps you find the blank and standard wells.

<!-- end list -->

``` r
my_col_names <- c("plate_row",
                  "plate_col",
                  "content",
                  "raw_fl")
```

  - This command will be different for different input files, especially
    the `skip` argument.

<!-- end list -->

``` r
raw_data <- fread("my_clariostar_data.csv",
                  skip = 11,
                  select = c(1:4),
                  col.names = my_col_names)
```

  - make sure it looks OK

<!-- end list -->

``` r
head(raw_data)
#>    plate_row plate_col   content raw_fl
#> 1:         A         1 Sample X1  20958
#> 2:         A         2 Sample X2  25736
#> 3:         A         3 Sample X3  36652
#> 4:         A         4 Sample X4    333
#> 5:         A         5 Sample X5  76296
#> 6:         A         6 Sample X6  19335
```

#### Add volumes

  - `AddVolumes()` has **side effects**, because it modifies `raw_data`

<!-- end list -->

``` r

AddVolumes(raw_data, "A1", "D5", 1, 50)
AddVolumes(raw_data, "A6", "H6", 1, 50)
AddVolumes(raw_data, "A7", "H11", 10, 800)
AddVolumes(raw_data, "E5", "H5", 10, 800)
```

#### Subtract background

  - Find the blank wells and the standard wells

<!-- end list -->

``` r
raw_data[grep("^Standard", content)]
#>    plate_row plate_col     content raw_fl volume_added sample_volume
#> 1:         C        12 Standard S1  28209           NA            NA
#> 2:         D        12 Standard S2  29456           NA            NA
#> 3:         E        12 Standard S3  30662           NA            NA
#> 4:         F        12 Standard S4 198981           NA            NA
#> 5:         G        12 Standard S5 200617           NA            NA
#> 6:         H        12 Standard S6 206913           NA            NA
raw_data[grep("^Blank", content)]
#>    plate_row plate_col content raw_fl volume_added sample_volume
#> 1:         A        12 Blank B    528           NA            NA
#> 2:         B        12 Blank B    483           NA            NA
```

  - Subtract the mean of the `blank_wells` from the `raw_fl` column

<!-- end list -->

``` r
background_subtracted <- SubtractBackground(raw_data, c("A12", "B12"))
```

#### Run the linear model

  - specify the standard wells and the amount of DNA added to them

<!-- end list -->

``` r
standard_wells <- data.table(well = paste0(LETTERS[3:8], 12),
                             amount = c(rep(10, 3), rep(100, 3)))
standard_wells
#>    well amount
#> 1:  C12     10
#> 2:  D12     10
#> 3:  E12     10
#> 4:  F12    100
#> 5:  G12    100
#> 6:  H12    100
```

  - calculate the amounts in the unknown
wells

<!-- end list -->

``` r
calculated_amounts <- CalculateAmounts(background_subtracted, standard_wells)
```

  - extract the original sample amounts from the results of
    `CalculateAmounts()`

<!-- end list -->

``` r
final_results <- ExtractResults(calculated_amounts)

head(final_results)
#>    plate_col plate_row volume_added calculated_concentration sample_volume
#> 1:         1         A            1                 10.07673            50
#> 2:         1         B            1                 15.01644            50
#> 3:         1         C            1                 12.73824            50
#> 4:         1         D            1                 12.84319            50
#> 5:         1         E            1                 13.65908            50
#> 6:         1         F            1                 14.82183            50
#>    total_amount
#> 1:     503.8367
#> 2:     750.8220
#> 3:     636.9122
#> 4:     642.1593
#> 5:     682.9540
#> 6:     741.0914
```
