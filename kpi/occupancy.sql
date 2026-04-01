-- Nome: Occupancy
-- Descrizione: Occupazione camere

SELECT 
    SUM(rooms) / SUM(nights) AS occupancy
FROM reservations
WHERE status = 'Confirmed';
