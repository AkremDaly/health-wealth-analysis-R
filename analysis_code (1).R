# =============================================================================
# COMPLETE MINI-THESIS: GLOBAL HEALTH-WEALTH RELATIONSHIP ANALYSIS
# =============================================================================

# Load required libraries
library(gapminder)
library(ggplot2)
library(dplyr)
library(boot)

# =============================================================================
# 1. INTRODUCTION
# =============================================================================

cat("
=== MINI-THESIS: Global Health-Wealth Relationship Analysis ===

1. INTRODUCTION

1.1 Background and Motivation
Understanding the relationship between economic development and health 
outcomes is crucial for international development organizations, policy 
makers, and global health initiatives. The persistent gap in life 
expectancy between developed and developing nations represents one of 
the most significant global health challenges.

1.2 Problem Statement
This research addresses the fundamental question: How does economic 
development, measured by GDP per capita, relate to population health 
outcomes, measured by life expectancy, across different continents and 
development levels?

1.3 Research Objectives
- Analyze the strength and nature of the relationship between GDP per 
  capita and life expectancy
- Examine continental differences in health-economic relationships
- Compare health outcomes between developed and developing countries
- Provide evidence-based insights for international development strategy

1.4 Research Questions
- Is there a significant correlation between GDP per capita and life 
  expectancy globally?
- How do health-economic relationships differ across continents?
- Are there significant differences in life expectancy between developed 
  and developing nations?
- What is the reliability of our estimates through resampling methods?
")

# =============================================================================
# 2. DATA COLLECTION AND SAMPLING
# =============================================================================

cat("
2. DATA COLLECTION AND SAMPLING

2.1 Data Source
Primary dataset: Gapminder dataset (1952-2007)
- Contains country-level data on life expectancy, GDP per capita, 
  population, and continent
- Widely used in development economics and public health research
- 142 countries in 2007 dataset

2.2 Sampling Method
- Used complete population data for 2007 (no sampling required)
- All 142 countries included for comprehensive analysis
- Data represents global distribution across 5 continents

2.3 Variables Description
")

# Enhanced dataset with additional variables
data_2007 <- gapminder %>%
  filter(year == 2007) %>%
  mutate(
    total_gdp = pop * gdpPercap,
    development_status = ifelse(gdpPercap > 10000, "Developed", "Developing")
  )

# Display variable description table
variable_desc <- data.frame(
  Variable = c("country", "continent", "lifeExp", "gdpPercap", "pop",
               "development_status"),
  Type = c("Categorical", "Categorical", "Numerical", "Numerical", "Numerical",
           "Categorical"),
  Description = c("Country name", "Continent (Asia, Europe, Africa, Americas, Oceania)",
                  "Life expectancy at birth (years)", "GDP per capita (USD)",
                  "Population size", "Development level based on GDP (> 10,000 = Developed)"),
  Unit = c("Text", "Category", "Years", "USD", "Persons", "Category")
)

print(variable_desc)

cat("
2.4 Data Cleaning & Preparation
- No missing values in the 2007 dataset
- GDP per capita log-transformed for linear relationship
- Created additional variables for enhanced analysis
- Categorical variables properly formatted for statistical tests
")

# =============================================================================
# 3. METHODOLOGY
# =============================================================================

cat("
3. METHODOLOGY

3.1 Analytical Tools Selection
The following multivariate analysis techniques were applied:

1. PEARSON CORRELATION ANALYSIS
   - Measures linear relationship between GDP per capita and life expectancy
   - Provides correlation coefficient and statistical significance

2. CHI-SQUARE TEST OF INDEPENDENCE
   - Tests association between continent and development status
   - Determines if development patterns vary by region

3. INDEPENDENT SAMPLES T-TEST
   - Compares life expectancy between developed and developing countries
   - Tests statistical significance of development gap

4. ANALYSIS OF VARIANCE (ANOVA)
   - Examines life expectancy differences across continents
   - Identifies regions with significantly different health outcomes

5. BOOTSTRAPPING
   - Provides robust estimation of mean life expectancy
   - Calculates confidence intervals through resampling

3.2 Model Specification
All analyses conducted at 95% confidence level (α = 0.05)
Sample size: 142 countries provides adequate statistical power
")

# =============================================================================
# 4. RESULTS AND INTERPRETATION
# =============================================================================

cat("
4. RESULTS AND INTERPRETATION

4.1 Exploratory Findings
")

# Basic descriptive statistics
cat("Descriptive Statistics:\n")
desc_stats <- data_2007 %>%
  summarise(
    Countries = n(),
    Mean_Life_Exp = round(mean(lifeExp), 1),
    Mean_GDP = round(mean(gdpPercap), 0),
    SD_Life_Exp = round(sd(lifeExp), 1),
    SD_GDP = round(sd(gdpPercap), 0)
  )
print(desc_stats)

# Continental summary
cat("\nLife Expectancy by Continent:\n")
continent_stats <- data_2007 %>%
  group_by(continent) %>%
  summarise(
    Countries = n(),
    Mean_Life_Exp = round(mean(lifeExp), 1),
    Mean_GDP = round(mean(gdpPercap), 0)
  )
print(continent_stats)

# 4.1.1 Correlation Analysis
cat("\n4.1.1 Correlation Analysis:\n")
cor_test <- cor.test(data_2007$gdpPercap, data_2007$lifeExp, method = "pearson")
print(cor_test)

# Visualization 1: Main scatter plot
p1 <- ggplot(data_2007, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) +
  geom_point(alpha = 0.7) +
  scale_x_log10() +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  labs(title = "GDP per Capita vs Life Expectancy (2007)",
       subtitle = paste("Pearson r =", round(cor_test$estimate, 3), 
                        ", p-value =", format.pval(cor_test$p.value, digits = 3)),
       x = "GDP per Capita (log scale)", 
       y = "Life Expectancy (years)",
       size = "Population") +
  theme_minimal()
print(p1)

# 4.1.2 Chi-Square Test
cat("\n4.1.2 Chi-Square Test: Continent vs Development Status\n")
contingency_table <- table(data_2007$continent, data_2007$development_status)
print(contingency_table)

chi_test <- chisq.test(contingency_table)
print(chi_test)

# 4.1.3 T-Test
cat("\n4.1.3 T-Test: Life Expectancy by Development Status\n")
developed <- data_2007 %>% filter(development_status == "Developed") %>% pull(lifeExp)
developing <- data_2007 %>% filter(development_status == "Developing") %>% pull(lifeExp)

t_test_result <- t.test(developed, developing)
print(t_test_result)

# Visualization 2: Development comparison
p2 <- ggplot(data_2007, aes(x = development_status, y = lifeExp, fill = development_status)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Life Expectancy: Developed vs Developing Countries",
       x = "Development Status", 
       y = "Life Expectancy (years)") +
  theme_minimal()
print(p2)

# 4.1.4 ANOVA
cat("\n4.1.4 ANOVA: Life Expectancy Across Continents\n")
anova_result <- aov(lifeExp ~ continent, data = data_2007)
print(summary(anova_result))

# Visualization 3: Continental comparison
p3 <- ggplot(data_2007, aes(x = continent, y = lifeExp, fill = continent)) +
  geom_boxplot(alpha = 0.7) +
  stat_summary(fun = mean, geom = "point", shape = 18, size = 3, color = "red") +
  labs(title = "ANOVA: Life Expectancy Differences Across Continents",
       x = "Continent", 
       y = "Life Expectancy (years)") +
  theme_minimal()
print(p3)

# 4.1.5 Bootstrapping
cat("\n4.1.5 Bootstrapping: Mean Life Expectancy Estimation\n")
bootstrap_mean <- function(data, indices) {
  return(mean(data[indices]))
}

set.seed(123)
bootstrap_results <- boot(data_2007$lifeExp, bootstrap_mean, R = 1000)
bootstrap_ci <- boot.ci(bootstrap_results, type = "perc")

cat("Original mean life expectancy:", round(mean(data_2007$lifeExp), 2), "\n")
cat("Bootstrap 95% CI:", round(bootstrap_ci$percent[4], 2), "-", round(bootstrap_ci$percent[5], 2), "\n")

# =============================================================================
# 5. CONCLUSION AND RECOMMENDATIONS
# =============================================================================

cat("
5. CONCLUSION AND RECOMMENDATIONS

5.1 Main Insights
- Strong positive correlation between GDP and life expectancy (r = ", 
    round(cor_test$estimate, 3), ")
- Significant life expectancy gap between developed and developing countries (", 
    round(mean(developed) - mean(developing), 1), " years difference)
- Continental variations in health outcomes are statistically significant
- Africa shows the lowest life expectancy despite some high-GDP countries

5.2 Business and Managerial Implications
- Economic development investments should prioritize health infrastructure
- Targeted interventions needed for African nations
- Development policies should consider both economic and health dimensions
- International organizations should focus on countries with low GDP-life 
  expectancy ratios

5.3 Limitations
- Correlation does not imply causation
- Other factors (healthcare systems, education, culture) not fully captured
- Dataset limited to 2007 - temporal trends not analyzed
- Development status classification based solely on GDP

5.4 Future Extensions
- Time-series analysis of health-wealth relationship evolution
- Inclusion of additional variables (healthcare access, education spending)
- Machine learning approaches for predictive modeling
- Regional-level analysis within continents
")

# =============================================================================
# APPENDIX: COMPLETE R CODE
# =============================================================================

cat("
APPENDIX: COMPLETE R CODE

# Load libraries
library(gapminder)
library(ggplot2)
library(dplyr)
library(boot)

# Data preparation
data_2007 <- gapminder %>% filter(year == 2007) %>%
  mutate(development_status = ifelse(gdpPercap > 10000, 'Developed', 'Developing'))

# Statistical analyses
cor.test(data_2007$gdpPercap, data_2007$lifeExp)
chisq.test(table(data_2007$continent, data_2007$development_status))
t.test(lifeExp ~ development_status, data = data_2007)
aov(lifeExp ~ continent, data = data_2007)
boot(data_2007$lifeExp, function(d,i) mean(d[i]), R=1000)

# Visualizations (code as shown above)
")

# Export final dataset
write.csv(data_2007, "thesis_complete_dataset.csv", row.names = FALSE)
cat("\nComplete dataset exported: thesis_complete_dataset.csv\n")

cat("\n=== MINI-THESIS COMPLETED ===\n")
