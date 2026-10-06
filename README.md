# Pre-Entrega 7: Ingeniería de Features con SQL Analítico Avanzado

Este proyecto implementa la ingeniería de características (Feature Engineering) orientada a análisis RFM y métricas avanzadas de comportamiento de clientes, procesadas en **SQL (DuckDB)** mediante scripts automatizados en **Python**.

## 📁 Estructura del Repositorio

```text
Pre-entrega 7 - Ingeniería de Features con SQL Analítico Avanzado/
├── .gitignore
├── README.md
├── SPEC.md
├── ejecutar.py
├── requirements.txt
├── output/
│   └── features_usuarios.csv
└── sql/
    ├── 01_datos.sql
    ├── 02_features_usuarios.sql
    └── 03_validaciones.sql
```

## 🚀 Requisitos e Instalación

1. **Instalar las dependencias:**
   ```bash
   pip install -r requirements.txt
   ```

## ⚙️ Ejecución

Ejecuta el script principal para procesar las consultas SQL, generar la tabla de features y validar los resultados:

```bash
python ejecutar.py
```

El dataset procesado y final estará disponible en `output/features_usuarios.csv`.

---

## 📊 Descripción de Features y su Relación con la Predicción de Churn

En este proyecto se implementaron transformaciones en SQL analítico avanzado (funciones de ventana `LAG`, `ROW_NUMBER`, `DENSE_RANK`, agreagaciones condicionales y CTEs) para construir un *Feature Store* orientado a predecir la pérdida/abandono de clientes (**Churn**):

| Feature | Descripción Técnica / Función SQL | Justificación Analítica para Modelo de Churn |
| :--- | :--- | :--- |
| **`recency_dias`** | Días transcurridos entre la última compra y la fecha de corte (`MAX(fecha_compra)`). | **Indicador clave de Churn:** A mayor número de días sin interactuar, mayor es la probabilidad de que el cliente haya abandonado el servicio. |
| **`frequency`** | Conteo total de transacciones realizadas (`COUNT`). | Mide el compromiso (*engagement*). Un cliente recurrente es menos propenso al Churn que uno esporádico. |
| **`monetary`** | Suma total acumulada del gasto (`SUM`). | Permite clasificar el impacto financiero del Churn (identificar fuga de clientes *High Value*). |
| **`gasto_ultimo_mes`** | Gasto registrado en los últimos 30 días (`SUM` condicional). | Evalúa la actividad económica reciente del usuario. |
| **`promedio_mensual_historico`** | Promedio mensual del gasto en el período previo. | Establece la línea base de consumo del cliente. |
| **`trend`** | Delta de gasto: `gasto_ultimo_mes - promedio_mensual_historico`. | **Señal temprana de alerta:** Un `trend` negativo evidencia una desaceleración en el gasto antes de que el cliente pase a estado inactivo total. |
| **`dias_entre_ultimas_compras`** | Días entre la penúltima y última compra usando `LAG(fecha_compra) OVER (PARTITION BY usuario_id ORDER BY fecha_compra)`. | Identifica si el ritmo de consumo del cliente se está alargando. |
| **`ranking_gasto`** | Posición del usuario según su consumo total usando `DENSE_RANK() OVER (ORDER BY monetary DESC)`. | Prioriza usuarios en el top de facturación para campañas de fidelización y retención preventiva. |

---

## 🛠️ Tratamiento de Valores Nulos y Consistencia de Datos

1. **Usuarios Inactivos / Sin Compras:** Para usuarios registrados que aún no realizaron compras (ej. Hernán Vega), se utiliza `COALESCE` para asignar `0.0` a métricas de gasto/frecuencia y un valor representativo de inactividad a la recencia (`181 días`), evitando que valores `NULL` interrumpan el entrenamiento de modelos de Machine Learning.
2. **Manejo del primer pedido:** Cuando no existe compra previa para calcular `LAG()`, se imputa `0` mediante `COALESCE` asegurando consistencia matemática.

