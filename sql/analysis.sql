-- ==========================================
-- EV Charging Station Usage & Performance
-- Analysis (Business Questions)
-- ==========================================

-- 1) Which stations are used the most and least?
-- Top 10 most utilised stations
SELECT
    station_id,
    avg_users_per_day
FROM fact_station_usage
ORDER BY avg_users_per_day DESC
LIMIT 10;

-- Bottom 10 least utilised stations
SELECT
    station_id,
    avg_users_per_day
FROM fact_station_usage
ORDER BY avg_users_per_day ASC
LIMIT 10;


-- 2) How does usage vary by charger type, cost, capacity, and distance?

-- Usage by charger type
SELECT
    dc.charger_type,
    COUNT(*) AS stations,
    ROUND(AVG(f.avg_users_per_day), 2) AS avg_usage,
    ROUND(AVG(f.charging_capacity_kw), 2) AS avg_capacity_kw,
    ROUND(AVG(f.cost_per_kwh), 3) AS avg_cost_per_kwh
FROM fact_station_usage f
JOIN dim_charger dc
    ON f.charger_id = dc.charger_id
GROUP BY dc.charger_type
ORDER BY avg_usage DESC;


-- Usage by distance band (CTE)
WITH base AS (
    SELECT
        f.station_id,
        ds.distance_to_city_km,
        f.avg_users_per_day
    FROM fact_station_usage f
    JOIN dim_station ds
        ON f.station_id = ds.station_id
),
banded AS (
    SELECT
        station_id,
        avg_users_per_day,
        CASE
            WHEN distance_to_city_km < 5 THEN '0-5 km'
            WHEN distance_to_city_km < 15 THEN '5-15 km'
            WHEN distance_to_city_km < 30 THEN '15-30 km'
            ELSE '30+ km'
        END AS distance_band
    FROM base
)
SELECT
    distance_band,
    COUNT(*) AS stations,
    ROUND(AVG(avg_users_per_day), 2) AS avg_usage
FROM banded
GROUP BY distance_band
ORDER BY avg_usage DESC;


-- Derived KPI: Usage per kW (utilisation proxy)
SELECT
    station_id,
    ROUND(avg_users_per_day / NULLIF(charging_capacity_kw, 0), 4) AS usage_per_kw
FROM fact_station_usage
ORDER BY usage_per_kw DESC;

-- Derived KPI: Cost-adjusted usage
SELECT
    station_id,
    ROUND(avg_users_per_day / NULLIF(cost_per_kwh, 0), 4) AS cost_adjusted_usage
FROM fact_station_usage
ORDER BY cost_adjusted_usage DESC;


-- 3) Which operators and charger types perform better?
SELECT
    op.operator_name,
    dc.charger_type,
    COUNT(*) AS stations,
    ROUND(AVG(f.avg_users_per_day), 2) AS avg_usage,
    ROUND(AVG(f.maintenance_frequency), 2) AS avg_maintenance,
    ROUND(AVG(f.rating), 2) AS avg_rating
FROM fact_station_usage f
JOIN dim_operator op
    ON f.operator_id = op.operator_id
JOIN dim_charger dc
    ON f.charger_id = dc.charger_id
GROUP BY
    op.operator_name,
    dc.charger_type
ORDER BY avg_usage DESC;


-- 4) Which stations should be prioritised for upgrades or maintenance?

WITH priority_calc AS (
    SELECT
        f.station_id,
        op.operator_name,
        dc.charger_type,
        f.avg_users_per_day,
        f.charging_capacity_kw,
        f.cost_per_kwh,
        ds.distance_to_city_km,
        CASE
            WHEN f.avg_users_per_day < 30 THEN 'High Priority'
            WHEN f.avg_users_per_day < 50 THEN 'Medium Priority'
            ELSE 'Low Priority'
        END AS priority_level
    FROM fact_station_usage f
    JOIN dim_station ds
        ON f.station_id = ds.station_id
    JOIN dim_operator op
        ON f.operator_id = op.operator_id
    JOIN dim_charger dc
        ON f.charger_id = dc.charger_id
)
SELECT *
FROM priority_calc
ORDER BY
    CASE priority_level
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        ELSE 3
    END,
    avg_users_per_day ASC;




