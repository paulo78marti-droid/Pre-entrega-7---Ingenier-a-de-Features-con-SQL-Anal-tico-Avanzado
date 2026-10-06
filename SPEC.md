# ESPECIFICACIÓN: Pre-Entrega 7 - Ingeniería de Features con SQL Analítico Avanzado

## Objetivo
Desarrollar y validar un pipeline de ingeniería de features sobre datos de comportamiento de compra utilizando SQL Analítico Avanzado (funciones de ventana, agregaciones condicionales y CTEs) en DuckDB.

## Features Generadas
1. **recency_dias**: Días transcurridos desde la última compra hasta la fecha de referencia.
2. **frequency**: Cantidad total de compras realizadas por el usuario.
3. **monetary**: Suma total gastada por el usuario.
4. **gasto_ultimo_mes**: Gasto total registrado en el último período/mes evaluado.
5. **promedio_mensual_historico**: Promedio del gasto en los meses anteriores.
6. **trend**: Diferencia entre el gasto del último mes y el promedio histórico (`gasto_ultimo_mes - promedio_mensual_historico`).
7. **dias_entre_ultimas_compras**: Días transcurridos entre la penúltima y la última compra registrada utilizando `LAG()`.
8. **ranking_gasto**: Posición/ranking del usuario según su consumo total utilizando `DENSE_RANK()`.

## Estructura del Proyecto
- `ejecutar.py`: Script ejecutable en Python con DuckDB.
- `requirements.txt`: Librerías requeridas (`duckdb`, `pandas`).
- `sql/`: Scripts SQL organizados (`01_datos.sql`, `02_features_usuarios.sql`, `03_validaciones.sql`).
- `output/`: Resultado procesado (`features_usuarios.csv`).
