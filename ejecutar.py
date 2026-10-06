"""Ejecuta las consultas SQL en DuckDB para generar el dataset de features.

Uso:
    pip install -r requirements.txt
    python ejecutar.py
"""
import duckdb

# 1. Crear conexión a base de datos DuckDB en memoria
con = duckdb.connect()

# 2. Cargar tablas y datos de prueba
with open("sql/01_datos.sql", encoding="utf-8") as f:
    con.execute(f.read())

# 3. Leer y ejecutar la consulta SQL principal de Ingeniería de Features
with open("sql/02_features_usuarios.sql", encoding="utf-8") as f:
    consulta_sql = f.read().strip().rstrip(";")

# Guardar los resultados en una tabla DuckDB
con.execute("CREATE TABLE features_usuarios AS " + consulta_sql)

# 4. Obtener los resultados en un DataFrame de Pandas
df_features = con.execute("SELECT * FROM features_usuarios").df()

print("=== Dataset Final de Features por Usuario ===")
print(df_features.to_string(index=False))

# 5. Exportar el resultado final a CSV en la carpeta output
df_features.to_csv("output/features_usuarios.csv", index=False)
print("\n[OK] Resultado guardado exitosamente en output/features_usuarios.csv")
