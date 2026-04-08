DROP TABLE IF EXISTS rp_kpi_daily_performance;

CREATE TABLE rp_kpi_daily_performance AS
SELECT
    i.inventory_date AS stay_date,
    i.inventory_date_key AS stay_date_key,
    i.hotel_id,
    i.hotel_name,
    i.total_units,
    i.ooo_units,
    i.blocked_units,
    i.closed_units,
    i.maintenance_units,
    i.available_units,
    i.is_open,

    COALESCE(SUM(rn.rooms_booked), 0) AS room_nights_sold,
    COALESCE(ROUND(SUM(rn.night_revenue_total), 2), 0) AS room_revenue,

    CASE
        WHEN COALESCE(SUM(rn.rooms_booked), 0) > 0
            THEN ROUND(SUM(rn.night_revenue_total) / SUM(rn.rooms_booked), 2)
        ELSE 0
    END AS adr,

    CASE
        WHEN i.available_units > 0
            THEN ROUND(COALESCE(SUM(rn.rooms_booked), 0) * 100.0 / i.available_units, 2)
        ELSE 0
    END AS occupancy_pct,

    CASE
        WHEN i.available_units > 0
            THEN ROUND(COALESCE(SUM(rn.night_revenue_total), 0) / i.available_units, 2)
        ELSE 0
    END AS revpar

FROM rp_fact_inventory_daily i
LEFT JOIN rp_fact_room_nights rn
    ON i.hotel_id = rn.hotel_id
   AND i.inventory_date = rn.stay_date
   AND rn.is_cancelled = 0
GROUP BY
    i.inventory_date,
    i.inventory_date_key,
    i.hotel_id,
    i.hotel_name,
    i.total_units,
    i.ooo_units,
    i.blocked_units,
    i.closed_units,
    i.maintenance_units,
    i.available_units,
    i.is_open;
