-- Nome: RevPAR
-- Descrizione: Revenue per Available Room

SELECT 
    SUM(room_revenue) / SUM(nights) AS revpar
FROM reservations
WHERE status = 'Confirmed';
