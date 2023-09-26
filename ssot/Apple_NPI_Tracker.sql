    select
    -- NOTE: TO GET DAILY VALUES, REPLACE THE LINE BELOW WITH "effective_date::date,"
    --date_trunc(month, effective_date)::date as month,
    effective_date:: date as date,
    -- NOTE: DESCRIPTORS
    affirm_entity,
    case
    when mixed_cart_flag = 1 then 'mixed_cart'
    else 'classic'
    end as mixed_cart_bin,
    merchant_ari,
    merchant_name,
    financial_segment,
    product,
    term_length,
    ib_flag,
    --NOTE: PROBABLY NOT NECESSARY FOR APPLE-SPECIFIC PULLS
    merchant_platform,
    -- NOTE: LOAN VOLUME TOTALS
    sum(authed_amount) as authed_amount,
    sum(capture_amount) as captured_amount,
    sum(total_refunded_amount) as refunded_amount,
    sum(loan_amount) as loan_amount,
    sum(downpayment_amount) as downpayment_amount,
    sum(gmv_net_refunds) as gmv_net_refunds,
    sum(vcn_dollars_gross) as vcn_amount,
    sum(mdr_dollars_gross) as mdr_amount,
    sum(transaction_fee_dollars_gross) as transaction_fee_amount,
    -- NOTE: TRANSACTIONS
    sum(authed_txns) as authed_txns,
    sum(captured_txns) as captured_txns,
    sum(refunded_txns) as refunded_txns
    -- NOTE: USING THE ACTUALS TABLE FOR NOW; ONCE I ADD FC, CAN SWITCH TO VOL TRENDS
    from prod__workspace__ca.scratch_t_strategicfinance.actuals_merchant_detail
    -- NOTE: REMOVE LINE BELOW IF YOU WANT ALL VOLUME EVER (GOES FAR BACK BC OF PAYBRIGHT)
    --       CHANGE THE DATE IF YOU WANT A DIFFERENT DATE RANGE
    where effective_date >= '2021-01-01'
        and financial_segment ilike '%apple%'
    group by 1,2,3,4,5,6,7,8,9,10
    -- NOTE: ORDERING SO THAT OUTPUT IS SORTED BY AFFIRM ENTITY, THEN MIXED CART vs. NOT, THEN MONTH
    order by 2 ,3,1,4,5,6,7,8,9,10;
