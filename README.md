# health-wealth-analysis-R
Mini-thesis in R: relationship between GDP per capita and life expectancy
# Global Health–Wealth Relationship Analysis (R)

Mini-thesis for **BA 340 – Data Analysis** at Tunis Business School. It studies how national wealth (GDP per capita) relates to population health (life expectancy) across 142 countries, using the Gapminder 2007 data.

## Research questions
1. Is GDP per capita correlated with life expectancy globally?
2. Does life expectancy differ across continents?
3. Do developed (GDP per capita > $10,000) and developing countries differ significantly?
4. How reliable is the estimated mean life expectancy (bootstrap)?

## Methods
Pearson correlation · Chi-square test of independence · Welch two-sample t-test · One-way ANOVA · Bootstrap confidence interval (1,000 resamples)

## Key results (2007, n = 142)
| Analysis | Result |
|---|---|
| Pearson correlation (GDP vs life expectancy) | r ≈ 0.68 (≈ 0.81 on log GDP), p < 0.001 |
| Developed vs developing | ≈ 14.8 years gap, p < 0.001 |
| ANOVA across continents | F ≈ 59.7, p < 0.001 |
| Mean life expectancy | 67.0 years, bootstrap 95% CI ≈ 65.2 – 68.8 |

Africa has the lowest mean life expectancy (54.8 years); Oceania the highest (80.7).

## Repository contents
- `analysis_code.R` – full, reproducible R script
- `thesis_complete_dataset.csv` – dataset used in the analysis
- `Thesis_Report.pdf` – written report

## How to run
```r
install.packages(c("gapminder", "ggplot2", "dplyr", "boot"))
source("analysis_code.R")
```

## Limitations
Correlation is not causation; one year only (2007); "developed" is defined by a GDP threshold alone.

## Tools
R, ggplot2, dplyr, boot, gapminder

**Author:** Akrem Daly – Accounting & Business Analytics, Tunis Business School
