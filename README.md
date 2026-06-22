# crashSeverity
Statistical analysis of factors associated with injury severity in pedestrian and cyclist crashes

# Background
Advancing active mobility has increasingly become a cornerstone of sustainable urban mobility agendas.
However, many cities face significant challenge in realizing a safer environment for active travel, largely due to a lack of evidence-based regulations regarding the factors that contribute to severe cyclist injuries, particularly in contexts where detailed collision data are unavailable.
This study examines the influence of vehicle and road characteristics on cyclist injury severity outcomes in collisions involving passenger cars.

# Research Question
How do vehicle and road characteristics influence injury severity outcomes for cyclists involved in collisions with passenger cars?

# Methodology
The analysis utilised police-reported road collision records from the United Kingdom STATS19 database covering the period 2019 - 2023.
A multivariate binary logistic regression model was employed to estimate the probability of killed or seriously injured (KSI) outcomes, by utilizing odds ratios for significance testing and average marginal effects for probability interpretation.

# Repository Structure
The repository is organised into data, scripts, and results to support a transparent and reproducible statistical analysis pipeline.

crashSeverity/

├── Data/        # Raw and processed datasets used in the analysis

├── Script/      # Reproducible R scripts for data processing and modelling

├── Result/      # Model outputs, diagnostic plots, and interpretation figures

└── README.md    # Project overview and methodological context

# Key Outputs
1. Cleaned and analysis-ready datasets derived from UK road safety records,
2. Nested binary logistic regression models for injury severity outcomes,
3. Model diagnostics and comparison results across nested specifications,
4. Tables summarising odds ratios and confidence intervals,
5. Visual outputs supporting model interpretation and comparison

# Notes on Data Availability
This repository uses secondary data obtained from publicly available sources, including road safety data STATS19 by Department for Transport
Vehicle-related attributes are obtained from external sources and linked at an aggregated level, such as vehicle mass, engine capacity by EEA website (http://co2cars.apps.eea.europa.eu/), and vehicle rating in protection for VRU by EURO NCAP (https://www.euroncap.com/en/ratings-rewards/latest-safety-ratings/).
No personal or identifiable information is included in this repository. 

Due to licensing and data governance considerations, some raw data files may not be redistributed directly.
Users are encouraged to obtain the original datasets from their respective official sources and follow the data preparation steps documented in this repository.
