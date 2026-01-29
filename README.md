# EV-Charging-Station-Usage-Upgrade-Priority-Analysis

This project analyses EV charging station usage data to understand performance patterns, identify under-utilised infrastructure, and support upgrade prioritisation decisions.
The analysis is designed from an operations and infrastructure analytics perspective, using SQL as the primary analysis tool, with Python and Tableau in supporting roles.

# Objective

- Identify under-utilised EV charging stations
- Analyse factors influencing station usage (cost, charger type, capacity, location)
- Segment stations into upgrade priority groups to support data-driven maintenance and investment decisions

# Dataset

- Source: Kaggle (simulated EV charging station data)
- Link: [https://www.kaggle.com/datasets/](https://www.kaggle.com/datasets/vivekattri/global-ev-charging-stations-dataset)
(Dataset used: detailed EV charging station usage and performance data)

The dataset contains information on:
- Average daily users
- Cost per kWh
- Charger type (AC / DC Fast)
- Charging capacity (kW)
- Distance to city
- Operator
- Maintenance frequency
- Customer ratings

This dataset is suitable for usage and performance analysis, not failure prediction.

# Tools & Technologies

SQL (Primary):
- Business analysis queries
- Aggregations, joins, KPIs
- Upgrade priority logic

Python (Supporting):
- Data inspection and validation
- Light preprocessing and schema alignment

Tableau:
Dashboard for operational insights and decision support

Data Model
The analysis follows a structured, star-schema-style approach:
- fact_station_usage
- dim_station
- dim_operator
- dim_charger

This structure supports scalable analysis and clean joins across dimensions.

# Key Analyses

Station usage vs cost per kWh
Usage comparison by charger type
Priority-based segmentation of stations
Identification of under-utilised infrastructure
Upgrade priority levels are derived using usage-based thresholds aligned with the dataset distribution.

# Tableau Dashboard

Dashboard Name:
- EV Charging Station Usage & Upgrade Priority Dashboard

The dashboard answers:
- How usage varies with pricing
- Which charger types perform better
- Which priority segment requires intervention first

The Tableau dashboard is provided as a packaged workbook (.twbx) containing all required extracts.
Intermediate CSV exports used during dashboard development are intentionally excluded from the repository.

# Repository Structure
```
ev-charging-station-usage-analysis/
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   └── 02_sql_validation.ipynb
├── sql/
│   ├── schema.sql
│   └── analysis.sql
├── tableau/
│   └── EV_Charging_Station_Usage_Upgrade_Analysis.twbx
├── README.md
└── .gitignore
```

# Key Insights

- Higher charging costs do not consistently correspond to higher usage
- DC Fast chargers show stronger average utilisation compared to AC chargers
- A distinct segment of stations exhibits persistently low usage, indicating upgrade or optimisation opportunities

# Recommendations

- Prioritise low-usage stations for pricing review or infrastructure upgrades
- Focus future investment on charger types with consistently higher utilisation
- Use priority segmentation to guide maintenance and capacity planning decisions
