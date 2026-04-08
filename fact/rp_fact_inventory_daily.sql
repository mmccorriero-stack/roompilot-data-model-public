DROP TABLE IF EXISTS rp_fact_room_nights;

CREATE TABLE rp_fact_room_nights AS
WITH RECURSIVE room_nights AS (
    SELECT
        reservation_id,
        hotel_id,
        source_system,
        booking_date,
        booking_date_key,
        checkin_date,
        checkout_date,
        reservation_status,
        channel_raw,
        segment_raw,
        rate_plan,
        board_code,
        policy_name,
        adults,
        teens,
        children,
        guest_count,
        rooms_booked,
        stay_nights,
        room_revenue,
        total_amount,
        paid_amount,
        is_cancelled,
        checkin_date AS stay_date
    FROM rp_fact_reservations
    WHERE checkin_date IS NOT NULL
      AND checkout_date IS NOT NULL
      AND julianday(checkout_date) > julianday(checkin_date)

    UNION ALL

    SELECT
        reservation_id,
        hotel_id,
        source_system,
        booking_date,
        booking_date_key,
        checkin_date,
        checkout_date,
        reservation_status,
        channel_raw,
        segment_raw,
        rate_plan,
        board_code,
        policy_name,
        adults,
        teens,
        children,
        guest_count,
        rooms_booked,
        stay_nights,
        room_revenue,
        total_amount,
        paid_amount,
        is_cancelled,
        date(stay_date, '+1 day')
    FROM room_nights
    WHERE date(stay_date, '+1 day') < checkout_date
)
SELECT
    reservation_id,
    hotel_id,
    source_system,
    booking_date,
    booking_date_key,
    checkin_date,
    checkout_date,
    stay_date,
    CAST(strftime('%Y%m%d', stay_date) AS INTEGER) AS stay_date_key,
    reservation_status,
    channel_raw,
    segment_raw,
    rate_plan,
    board_code,
    policy_name,
    adults,
    teens,
    children,
    guest_count,
    rooms_booked,
    stay_nights,
    ROUND(room_revenue, 2) AS room_revenue,
    ROUND(total_amount, 2) AS total_amount,
    ROUND(paid_amount, 2) AS paid_amount,
    CASE
        WHEN stay_nights > 0 THEN ROUND(room_revenue / stay_nights, 2)
        ELSE 0
    END AS night_revenue_total,
    CASE
        WHEN stay_nights > 0 AND rooms_booked > 0 THEN ROUND(room_revenue / stay_nights / rooms_booked, 2)
        ELSE 0
    END AS night_revenue_per_unit,
    CASE
        WHEN stay_date = checkin_date THEN 1
        ELSE 0
    END AS is_arrival_night,
    CASE
        WHEN date(stay_date, '+1 day') = checkout_date THEN 1
        ELSE 0
    END AS is_last_night,
    is_cancelled
FROM room_nights;
