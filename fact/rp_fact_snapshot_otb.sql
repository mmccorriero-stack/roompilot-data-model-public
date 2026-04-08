DROP TABLE IF EXISTS rp_fact_snapshot_otb;

CREATE TABLE rp_fact_snapshot_otb AS
WITH RECURSIVE snapshot_expanded AS (
    SELECT
        r.reservation_id,
        r.hotel_id,
        r.source_system,
        r.booking_date AS snapshot_date,
        CAST(strftime('%Y%m%d', r.booking_date) AS INTEGER) AS snapshot_date_key,
        rn.stay_date,
        rn.stay_date_key,
        rn.rooms_booked,
        rn.night_revenue_total,
        r.is_cancelled
    FROM rp_fact_reservations r
    INNER JOIN rp_fact_room_nights rn
        ON r.reservation_id = rn.reservation_id
    WHERE r.booking_date IS NOT NULL
      AND rn.stay_date IS NOT NULL
      AND julianday(rn.stay_date) >= julianday(r.booking_date)
      AND r.is_cancelled = 0

    UNION ALL

    SELECT
        reservation_id,
        hotel_id,
        source_system,
        date(snapshot_date, '+1 day') AS snapshot_date,
        CAST(strftime('%Y%m%d', date(snapshot_date, '+1 day')) AS INTEGER) AS snapshot_date_key,
        stay_date,
        stay_date_key,
        rooms_booked,
        night_revenue_total,
        is_cancelled
    FROM snapshot_expanded
    WHERE date(snapshot_date, '+1 day') <= stay_date
)
SELECT
    snapshot_date,
    snapshot_date_key,
    stay_date,
    stay_date_key,
    hotel_id,
    source_system,
    SUM(rooms_booked) AS rooms_otb,
    ROUND(SUM(night_revenue_total), 2) AS revenue_otb,
    CASE
        WHEN SUM(rooms_booked) > 0
            THEN ROUND(SUM(night_revenue_total) / SUM(rooms_booked), 2)
        ELSE 0
    END AS adr_otb
FROM snapshot_expanded
GROUP BY
    snapshot_date,
    snapshot_date_key,
    stay_date,
    stay_date_key,
    hotel_id,
    source_system;
