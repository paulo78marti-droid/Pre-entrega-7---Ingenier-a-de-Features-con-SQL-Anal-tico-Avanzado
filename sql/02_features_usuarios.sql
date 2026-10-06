-- 02_features_usuarios.sql
-- Consulta principal para generación de features de usuarios (RFM + Trend)

WITH ultimas_compras AS (
    SELECT 
        usuario_id,
        fecha_compra,
        monto,
        -- Obtenemos la fecha de la compra anterior para calcular el intervalo
        LAG(fecha_compra) OVER (PARTITION BY usuario_id ORDER BY fecha_compra) AS fecha_compra_anterior,
        -- Numeramos las compras en orden descendente para identificar la última
        ROW_NUMBER() OVER (PARTITION BY usuario_id ORDER BY fecha_compra DESC) AS orden_compra
    FROM compras
),
diferencia_compras AS (
    SELECT 
        usuario_id,
        DATEDIFF('day', fecha_compra_anterior, fecha_compra) AS dias_entre_ultimas_compras
    FROM ultimas_compras
    WHERE orden_compra = 1
),
metricas_base AS (
    SELECT 
        u.usuario_id,
        u.nombre,
        -- Recency: días transcurridos desde la última compra hasta la fecha de corte (2024-06-01)
        COALESCE(DATEDIFF('day', MAX(c.fecha_compra), DATE '2024-06-01'), 181) AS recency_dias,
        -- Frequency: cantidad total de compras únicas
        COUNT(c.compra_id) AS frequency,
        -- Monetary: gasto total acumulado
        COALESCE(SUM(c.monto), 0.0) AS monetary,
        -- Gasto en el último mes evaluado (mayo 2024)
        COALESCE(SUM(CASE WHEN c.fecha_compra >= DATE '2024-05-01' THEN c.monto ELSE 0.0 END), 0.0) AS gasto_ultimo_mes,
        -- Promedio mensual del período histórico previo (5 meses)
        COALESCE(SUM(CASE WHEN c.fecha_compra < DATE '2024-05-01' THEN c.monto ELSE 0.0 END) / 5.0, 0.0) AS promedio_mensual_historico,
        -- Intervalo de días entre la penúltima y última compra
        COALESCE(d.dias_entre_ultimas_compras, 0) AS dias_entre_ultimas_compras
    FROM usuarios u
    LEFT JOIN compras c ON u.usuario_id = c.usuario_id
    LEFT JOIN diferencia_compras d ON u.usuario_id = d.usuario_id
    GROUP BY u.usuario_id, u.nombre, d.dias_entre_ultimas_compras
)
SELECT 
    usuario_id,
    nombre,
    recency_dias,
    frequency,
    monetary,
    gasto_ultimo_mes,
    promedio_mensual_historico,
    -- Trend: delta entre el gasto del último mes y el promedio histórico
    ROUND(gasto_ultimo_mes - promedio_mensual_historico, 1) AS trend,
    dias_entre_ultimas_compras,
    -- Ranking de usuarios según gasto total acumulado
    DENSE_RANK() OVER (ORDER BY monetary DESC) AS ranking_gasto
FROM metricas_base
ORDER BY usuario_id;
