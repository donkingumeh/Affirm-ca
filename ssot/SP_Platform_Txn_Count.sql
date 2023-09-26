select
affirm_entity,
merchant_platform,
CASE
        WHEN LOWER(merchant_platform) IN ('cybersource', 'wix', 'aspenware', 'x-cart', 'celerant') THEN 'Other (New Platform - Managed)'
        WHEN LOWER(merchant_platform) IN ('magento1.x', 'magento') THEN 'Magento 1'
        ELSE merchant_platform
    END AS SP_Reporting_Name,
DATE_TRUNC(MONTH, effective_date)::date AS start_of_month,
sum(loan_amount) loan,
sum(gmv_net_refunds) gmv,
count(distinct MERCHANT_ARI) as merchant_count
from prod__workspace__ca.scratch_t_strategicfinance.actuals_merchant_detail
where EFFECTIVE_DATE >= '2023-07-01'
group by 1,2,3,4;
