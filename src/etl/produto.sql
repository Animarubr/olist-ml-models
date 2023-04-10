WITH tb_join AS (
    SELECT DISTINCT t2.idVendedor,
        t3.*
    FROM pedido AS t1
        LEFT JOIN item_pedido AS t2 ON t1.idPedido = t2.idPedido
        LEFT JOIN produto AS t3 ON t2.idProduto = t3.idProduto
    WHERE t1.dtPedido < '2018-01-01'
        AND t1.dtPedido >= DATE('2018-01-01', '-6 months')
        AND t2.idVendedor IS NOT NULL
),
tb_summary AS (
    SELECT idVendedor,
        -- FIX: Calcular a mediana, como estou usando SQLite não encontrei uma forma de calcula-lá
        AVG(COALESCE(nrFotos, 0)) AS avgFotos,
        AVG(vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS avgVolumeProduto,
        -- (vlComprimentoCm * vlAlturaCm * vlLarguraCm) * 0.5 -1 AS medianVolumeProduto,
        MIN(vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS minVolumeProduto,
        MAX(vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS maxVolumeProduto
    FROM tb_join
    GROUP BY idVendedor
)
SELECT *
FROM tb_join