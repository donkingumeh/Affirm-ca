select
merchant_ari,
merchant_name,
merchant_platform,
min(date_trunc(month,effective_date)) first_date
from PROD__WORKSPACE__CA.SCRATCH_T_STRATEGICFINANCE.VOL_TRENDS_DAILY
where AUTHED_AMOUNT > 0
group by 1,2,3
order by 1,2,3;
