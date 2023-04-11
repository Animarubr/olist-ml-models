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
        MAX(vlComprimentoCm * vlAlturaCm * vlLarguraCm) AS maxVolumeProduto,
        COUNT(
            CASE
                WHEN descCategoria = 'cama_mesa_banho' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriacama_mesa_banho,
        COUNT(
            CASE
                WHEN descCategoria = 'beleza_saude' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriabeleza_saude,
        COUNT(
            CASE
                WHEN descCategoria = 'esporte_lazer' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriaesporte_lazer,
        COUNT(
            CASE
                WHEN descCategoria = 'informatica_acessorios' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriainformatica_acessorios,
        COUNT(
            CASE
                WHEN descCategoria = 'moveis_decoracao' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriamoveis_decoracao,
        COUNT(
            CASE
                WHEN descCategoria = 'utilidades_domesticas' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriautilidades_domesticas,
        COUNT(
            CASE
                WHEN descCategoria = 'relogios_presentes' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriarelogios_presentes,
        COUNT(
            CASE
                WHEN descCategoria = 'telefonia' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriatelefonia,
        COUNT(
            CASE
                WHEN descCategoria = 'automotivo' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriaautomotivo,
        COUNT(
            CASE
                WHEN descCategoria = 'brinquedos' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriabrinquedos,
        COUNT(
            CASE
                WHEN descCategoria = 'cool_stuff' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriacool_stuff,
        COUNT(
            CASE
                WHEN descCategoria = 'ferramentas_jardim' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriaferramentas_jardim,
        COUNT(
            CASE
                WHEN descCategoria = 'perfumaria' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriaperfumaria,
        COUNT(
            CASE
                WHEN descCategoria = 'bebes' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriabebes,
        COUNT(
            CASE
                WHEN descCategoria = 'eletronicos' THEN idProduto
            END
        ) / COUNT(DISTINCT idProduto) AS pctCategoriaeletronicos
    FROM tb_join
    GROUP BY idVendedor
)
SELECT '2018-01-01' AS dtReference,
    *
FROM tb_summary