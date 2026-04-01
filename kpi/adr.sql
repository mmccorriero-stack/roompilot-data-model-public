-- Nome: ADR
-- Descrizione: Average Daily Rate
-- Formula: Revenue / Nights

SELECT 
    SUM(room_revenue) / SUM(nights) AS adr
FROM reservations
WHERE status = 'Confirmed';
