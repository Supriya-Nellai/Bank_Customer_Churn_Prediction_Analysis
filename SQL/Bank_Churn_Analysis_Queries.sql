-- 1. Overall Churn Rate
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS total_churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM bank_churn;

-- 2. Churn by Geography
SELECT
    Geography,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM bank_churn
GROUP BY Geography
ORDER BY churn_rate DESC;

-- 3. Churn by Gender
SELECT
    Gender,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM bank_churn
GROUP BY Gender;

-- 4. Churn by Age Group
SELECT
    CASE
        WHEN Age < 30 THEN '18-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM bank_churn
GROUP BY age_group
ORDER BY churn_rate DESC;

-- 5. Churn by Number of Products
SELECT
    NumOfProducts,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM bank_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- 6. Active vs Inactive Members
SELECT
    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS member_status,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM bank_churn
GROUP BY IsActiveMember;

-- 7. Credit Card Holders vs Non-Holders
SELECT
    CASE
        WHEN HasCrCard = 1 THEN 'Has Credit Card'
        ELSE 'No Credit Card'
    END AS card_status,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM bank_churn
GROUP BY HasCrCard;

-- 8. Average Balance, Salary and Credit Score
SELECT
    CASE
        WHEN Exited = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    ROUND(AVG(Balance),2) AS avg_balance,
    ROUND(AVG(EstimatedSalary),2) AS avg_salary,
    ROUND(AVG(CreditScore),2) AS avg_credit_score
FROM bank_churn
GROUP BY Exited;

-- 9. Tenure vs Churn
SELECT
    Tenure,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY Tenure
ORDER BY Tenure;

-- 10. Geography + Gender
SELECT
    Geography,
    Gender,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY Geography, Gender
ORDER BY churn_rate DESC;

-- 11. Credit Score Bands
SELECT
    CASE
        WHEN CreditScore < 500 THEN 'Poor (<500)'
        WHEN CreditScore BETWEEN 500 AND 649 THEN 'Fair (500-649)'
        WHEN CreditScore BETWEEN 650 AND 749 THEN 'Good (650-749)'
        ELSE 'Excellent (750+)'
    END AS credit_band,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY credit_band
ORDER BY churn_rate DESC;

-- 12. Zero Balance vs Has Balance
SELECT
    CASE
        WHEN Balance = 0 THEN 'Zero Balance'
        ELSE 'Has Balance'
    END AS balance_status,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY balance_status;

-- 13. Salary Quartiles vs Churn 
SELECT
    salary_quartile,
    COUNT(*) AS total,
    SUM(Exited) AS churned,
    ROUND(SUM(Exited) * 100.0 / COUNT(*),2) AS churn_rate
FROM
(
    SELECT
        EstimatedSalary,
        Exited,
        NTILE(4) OVER (ORDER BY EstimatedSalary) AS salary_quartile
    FROM bank_churn
) AS t
GROUP BY salary_quartile
ORDER BY salary_quartile;

-- 14. Top 10 Highest Balance Churned Customers
SELECT
    CustomerId,
    Surname,
    Geography,
    Balance,
    NumOfProducts,
    IsActiveMember
FROM bank_churn
WHERE Exited = 1
ORDER BY Balance DESC
LIMIT 10;

-- 15. Products × Active Member Risk Matrix
SELECT
    NumOfProducts,
    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS member_status,
    COUNT(*) AS total,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM bank_churn
GROUP BY NumOfProducts, member_status
ORDER BY churn_rate DESC;