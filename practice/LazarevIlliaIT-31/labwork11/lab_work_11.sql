SELECT
    clients.id,
    clients.last_name,
    COUNT(visits.id) AS total_visits
FROM clients
JOIN visits ON visits.client_id = clients.id
GROUP BY clients.id

SELECT
    clients.id,
    clients.last_name,
    COUNT(visits.id) AS total_visits
FROM clients
JOIN visits ON visits.client_id = clients.id
GROUP BY clients.id
HAVING COUNT(visits.id) >= 2;

SELECT
    clients.id,
    clients.last_name,
    COUNT(visits.id) AS total_visits
FROM clients
JOIN visits ON visits.client_id = clients.id
WHERE visits.visit_date >= '2026-01-01'
GROUP BY clients.id
HAVING COUNT(visits.id) >= 2;


SELECT
    clients.id,
    clients.first_name,
    clients.last_name,
    COUNT(visits.id) AS total_visits
FROM clients
LEFT JOIN visits ON visits.client_id = clients.id
WHERE visits.visit_date >= '2026-01-01'
GROUP BY clients.id
HAVING COUNT(visits.id) >= 2;