# crashSeverity
Statistical analysis of factors associated with injury severity in pedestrian and cyclist crashes

# Background
Road traffic crashes remain a major public health and transport safety challenge worldwide, with pedestrians and cyclists consistently experiencing a disproportionate burden of severe and fatal injuries.
As countries increasingly promote active travel to support sustainable and healthy mobility, ensuring safe road environments for vulnerable road users has become a critical policy objective.

From a road safety perspective, injury severity in pedestrian and cyclist crashes is not solely determined by user behaviour, but is strongly influenced by system-level factors, particularly vehicle and road characteristics.
Within the Safe System approach, vehicles and road infrastructure are designed to mitigate the consequences of human error by reducing impact forces and exposure to high-risk conflict situations.
Understanding how these factors interact to influence injury severity is therefore essential to inform effective interventions in vehicle design and road infrastructure planning.

# Research Question
How do vehicle and road characteristics influence injury severity outcomes for pedestrians and cyclists involved in collisions with passenger cars?

# Methodology
This study uses secondary dataset from road safety UK's statistics (STATS19) from 2020 to 2024, to examine injury seerity outcomes among pedestrians and cyclists. In addition, to expand vehicle characteristics, Euro NCAP and European Environment Agency data was included. Key explanatory variables were derived from vehicles, road, and situational conditions variables at the time of the crash.

Injury severity was modelled as a binary logistic regression. To assess the incremental contribution of different factor groups, a series of nested models was estimated, beginning with confounding factors and subsequently adding vehicle- and road-related characteristics. Model performance and robustness were evaluated using standard diagnostic (multicollinearity assessment) and comparison metrics (psedo R-square, AIC) while results were interpreted through odds ratios and marginal effects to support data driven policy insights.

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
