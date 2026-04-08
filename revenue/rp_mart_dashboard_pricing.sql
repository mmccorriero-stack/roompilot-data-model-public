DROP TABLE IF EXISTS rp_mart_dashboard_pricing;

CREATE TABLE rp_mart_dashboard_pricing AS
SELECT
    p.stay_date,
    p.hotel_id,
    p.hotel_name,

    d.day_name_it,
    d.month_name_it,
    d.week_num,
    d.is_weekend,

    i.total_units,
    i.available_units,
    i.ooo_units,
    i.blocked_units,
    i.closed_units,
    i.maintenance_units,
    i.is_open,

    k.room_nights_sold,
    k.room_revenue,
    k.adr,
    k.occupancy_pct,
    k.revpar,

    p.pickup_rooms,
    p.pickup_revenue,
    p.days_to_arrival,

    p.current_adr,
    p.suggested_price,
    ROUND(p.suggested_price - p.current_adr, 2) AS price_delta,

    CASE
        WHEN p.current_adr > 0
            THEN ROUND((p.suggested_price - p.current_adr) * 100.0 / p.current_adr, 2)
        ELSE 0
    END AS price_delta_pct,

    p.confidence_level,
    p.total_score,
    p.explanation

FROM rp_pricing_engine_v2 p
LEFT JOIN dim_date d
    ON p.stay_date = d.full_date
LEFT JOIN rp_fact_inventory_daily i
    ON p.hotel_id = i.hotel_id
   AND p.stay_date = i.inventory_date
LEFT JOIN rp_kpi_daily_performance k
    ON p.hotel_id = k.hotel_id
   AND p.stay_date = k.stay_date;
