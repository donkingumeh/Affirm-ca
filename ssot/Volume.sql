SELECT
    merchant_platform,
    merchant_name,
    CASE
        WHEN EXTRACT(MONTH FROM effective_date) <= 6 THEN EXTRACT(YEAR FROM effective_date)
        ELSE EXTRACT(YEAR FROM effective_date) + 1
    END AS fy,
    YEAR(effective_date) AS calendar_year,
    MONTH(effective_date) AS month,
    DATE_TRUNC(MONTH, effective_date)::date AS start_of_month,
    SUM(gmv_net_refunds) AS gmv,
    SUM(vcn_dollars_gross) AS vcn,
    SUM(mdr_dollars_gross) AS mdr,
    SUM(transaction_fee_dollars_gross) AS transaction_fee,
    CASE
        WHEN LOWER(merchant_platform) IN ('cybersource', 'wix', 'aspenware', 'x-cart', 'celerant') THEN 'Other (New Platform - Managed)'
        WHEN LOWER(merchant_platform) IN ('magento1.x', 'magento') THEN 'Magento 1'
        ELSE merchant_platform
    END AS SP_Reporting_Name,
    CASE
        WHEN SUM(capture_amount) = 0 THEN 0 -- Handle division by zero error
        ELSE (((SUM(mdr_dollars_gross) + SUM(vcn_dollars_gross)) / SUM(capture_amount)) * SUM(gmv_net_refunds)) + SUM(transaction_fee_dollars_gross)
    END AS revenue
FROM PROD__WORKSPACE__CA.SCRATCH_T_STRATEGICFINANCE.ACTUALS_MERCHANT_DETAIL
WHERE effective_date >= '2023-07-01'
GROUP BY 1, 2, 3, 4, 5, 6, 11; -- Include the new column in the GROUP BY clause
