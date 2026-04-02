DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date AS
WITH RECURSIVE calendar(full_date) AS (
    SELECT date('2024-01-01')
    UNION ALL
    SELECT date(full_date, '+1 day')
    FROM calendar
    WHERE full_date < date('2030-12-31')
)
SELECT
    CAST(strftime('%Y%m%d', full_date) AS INTEGER) AS date_key,
    full_date,
    CAST(strftime('%Y', full_date) AS INTEGER) AS year_num,
    CAST(strftime('%m', full_date) AS INTEGER) AS month_num,
    CASE strftime('%m', full_date)
        WHEN '01' THEN 'Gennaio'
        WHEN '02' THEN 'Febbraio'
        WHEN '03' THEN 'Marzo'
        WHEN '04' THEN 'Aprile'
        WHEN '05' THEN 'Maggio'
        WHEN '06' THEN 'Giugno'
        WHEN '07' THEN 'Luglio'
        WHEN '08' THEN 'Agosto'
        WHEN '09' THEN 'Settembre'
        WHEN '10' THEN 'Ottobre'
        WHEN '11' THEN 'Novembre'
        WHEN '12' THEN 'Dicembre'
    END AS month_name_it,
    CAST(((CAST(strftime('%m', full_date) AS INTEGER) - 1) / 3) + 1 AS INTEGER) AS quarter_num,
    CAST(strftime('%W', full_date) AS INTEGER) AS week_num,
    CAST(strftime('%d', full_date) AS INTEGER) AS day_num,
    CASE strftime('%w', full_date)
        WHEN '0' THEN 'Domenica'
        WHEN '1' THEN 'Lunedi'
        WHEN '2' THEN 'Martedi'
        WHEN '3' THEN 'Mercoledi'
        WHEN '4' THEN 'Giovedi'
        WHEN '5' THEN 'Venerdi'
        WHEN '6' THEN 'Sabato'
    END AS day_name_it,
    CASE strftime('%w', full_date)
        WHEN '1' THEN 1
        WHEN '2' THEN 2
        WHEN '3' THEN 3
        WHEN '4' THEN 4
        WHEN '5' THEN 5
        WHEN '6' THEN 6
        WHEN '0' THEN 7
    END AS day_of_week_num,
    CASE
        WHEN strftime('%w', full_date) IN ('0', '6') THEN 1
        ELSE 0
    END AS is_weekend,
    CASE
        WHEN strftime('%d', full_date) = '01' THEN 1
        ELSE 0
    END AS is_month_start,
    CASE
        WHEN date(full_date, '+1 day') = date(full_date, 'start of month', '+1 month') THEN 1
        ELSE 0
    END AS is_month_end
FROM calendar;
