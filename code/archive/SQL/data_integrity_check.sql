SELECT Id, COUNT(ActivityDate) as day_count
FROM activity_daily # merged table
GROUP BY Id
ORDER BY day_count asc;