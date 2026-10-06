-- 03_validaciones.sql
-- Consultas de comprobación y calidad de datos sobre las features calculadas

-- Validación 1: Verificar el total de usuarios y usuarios activos
SELECT 
    COUNT(*) AS total_usuarios,
    SUM(CASE WHEN frequency > 0 THEN 1 ELSE 0 END) AS usuarios_activos,
    SUM(CASE WHEN frequency = 0 THEN 1 ELSE 0 END) AS usuarios_inactivos
FROM features_usuarios;

-- Validación 2: Usuarios con mayor tendencia de crecimiento en gasto
SELECT usuario_id, nombre, monetary, trend 
FROM features_usuarios 
ORDER BY trend DESC;

-- Validación 3: Top 3 usuarios por ranking de gasto
SELECT usuario_id, nombre, monetary, ranking_gasto 
FROM features_usuarios 
WHERE ranking_gasto <= 3 
ORDER BY ranking_gasto;
