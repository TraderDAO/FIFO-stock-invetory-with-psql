SELECT
    id,
    TIME,
    datetime,
    orderid AS buy_order_id,
    LAG(orderid) over w AS prev_buy_order_id,
    symbol,
    price,
    COALESCE(LAG(price) over w, 0) AS prev_bought_price,
    amount,
    COALESCE(LAG(amount) over w, 0) AS prev_bought_qty,
    SUM(amount) over w AS cum_bought_qty,
    COALESCE(SUM(amount) over prevw, 0) AS cum_prev_bought_qty,
    cost,
    COALESCE(LAG(cost) over w, 0) AS prev_bought_cost,
    SUM(cost) over w AS total_cost,
    COALESCE(SUM(cost) over prevw, 0) AS prev_total_cost
FROM
    PUBLIC.orderstable
WHERE
    symbol = 'BCH'
    AND side = 'buy' window w AS (
        PARTITION BY symbol
        ORDER BY
            TIME
    ),
    prevw AS (
        PARTITION BY symbol
        ORDER BY
            TIME rows BETWEEN unbounded preceding
            AND 1 preceding
    )
