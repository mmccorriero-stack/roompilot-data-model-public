CREATE TABLE dim_market AS
SELECT DISTINCT
    market_source,
    market_segment
FROM stg_reservations;
