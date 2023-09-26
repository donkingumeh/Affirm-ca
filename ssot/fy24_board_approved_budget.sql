select
date_trunc(month,effective_date)::date month,
financial_segment,
sum(budget_gmv_net_refunds) gmv,
sum(budget_capture_amount) capture,
sum(budget_loan_amount) loan
from PROD__WORKSPACE__US.SCRATCH_T_STRATEGICFINANCE.VOL_TRENDS_DAILY
where REGION = 'Affirm CA'
and EFFECTIVE_DATE between '2023-07-01' and '2024-06-30'
and FINANCIAL_SEGMENT not in ('Pay Now','Paybright')
group by 1,2
order by 2,1;
