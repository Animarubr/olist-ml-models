WITH tb_join AS (
    SELECT t2.*,
        t3.idVendedor
    FROM pedido AS t1
        LEFT JOIN pagamento_pedido AS t2 ON t1.idPedido = t2.idPedido
        LEFT JOIN item_pedido AS t3 ON t1.idPedido = t3.idPedido
    WHERE t1.dtPedido <= '2018-01-01'
        AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
        AND t3.idVendedor IS NOT NULL
),
tb_group AS (
    SELECT idVendedor,
        descTipoPagamento,
        count(DISTINCT idPedido) AS qtdePedidoMeioPagamento,
        sum(vlPagamento) as vlPedidoMeioPagamento
    FROM tb_join
    GROUP BY idVendedor,
        descTipoPagamento
    ORDER BY idVendedor,
        descTipoPagamento
)
SELECT idVendedor,
    sum(
        CASE
            WHEN descTipoPagamento = 'boleto' THEN qtdePedidoMeioPagamento
            ELSE 0
        END
    ) AS qtde_boleto,
    sum(
        CASE
            WHEN descTipoPagamento = 'credit_card' THEN qtdePedidoMeioPagamento
            ELSE 0
        END
    ) AS qtde_credit_card,
    sum(
        CASE
            WHEN descTipoPagamento = 'voucher' THEN qtdePedidoMeioPagamento
            ELSE 0
        END
    ) AS qtde_voucher,
    sum(
        CASE
            WHEN descTipoPagamento = 'debit_card' THEN qtdePedidoMeioPagamento
            ELSE 0
        END
    ) AS qtde_debit_card,
    sum(
        CASE
            WHEN descTipoPagamento = 'boleto' THEN vlPedidoMeioPagamento
            ELSE 0
        END
    ) AS valor_boleto,
    sum(
        CASE
            WHEN descTipoPagamento = 'credit_card' THEN vlPedidoMeioPagamento
            ELSE 0
        END
    ) AS valor_credit_card,
    sum(
        CASE
            WHEN descTipoPagamento = 'voucher' THEN vlPedidoMeioPagamento
            ELSE 0
        END
    ) AS valor_voucher,
    sum(
        CASE
            WHEN descTipoPagamento = 'debit_card' THEN vlPedidoMeioPagamento
            ELSE 0
        END
    ) AS valor_debit_card,
    sum(
        CASE
            WHEN descTipoPagamento = 'boleto' THEN qtdePedidoMeioPagamento
            ELSE 0
        END
    ) / sum(qtdePedidoMeioPagamento) AS pct_qtd_boleto,
    sum(
        CASE
            WHEN descTipoPagamento = 'credit_card' THEN qtdePedidoMeioPagamento
            ELSE 0
        END
    ) / sum(qtdePedidoMeioPagamento) AS pct_qtd_credit_card,
    sum(
        CASE
            WHEN descTipoPagamento = 'voucher' THEN qtdePedidoMeioPagamento
            ELSE 0
        END
    ) / sum(qtdePedidoMeioPagamento) AS pct_qtd_voucher,
    sum(
        CASE
            WHEN descTipoPagamento = 'debit_card' THEN qtdePedidoMeioPagamento
            ELSE 0
        END
    ) / sum(qtdePedidoMeioPagamento) AS pct_qtd_debit_card,
    sum(
        CASE
            WHEN descTipoPagamento = 'boleto' THEN vlPedidoMeioPagamento
            ELSE 0
        END
    ) / sum(vlPedidoMeioPagamento) AS pct_valor_boleto,
    sum(
        CASE
            WHEN descTipoPagamento = 'credit_card' THEN vlPedidoMeioPagamento
            ELSE 0
        END
    ) / sum(vlPedidoMeioPagamento) AS pct_valor_credit_card,
    sum(
        CASE
            WHEN descTipoPagamento = 'voucher' THEN vlPedidoMeioPagamento
            ELSE 0
        END
    ) / sum(vlPedidoMeioPagamento) AS pct_valor_voucher,
    sum(
        CASE
            WHEN descTipoPagamento = 'debit_card' THEN vlPedidoMeioPagamento
            ELSE 0
        END
    ) / sum(vlPedidoMeioPagamento) AS pct_valor_debit_card
FROM tb_group
GROUP BY 1