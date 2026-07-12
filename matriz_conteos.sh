#!/bin/bash

# 1. Crear un archivo temporal con la lista de todos los miRNAs únicos
# y ordenarlos alfabéticamente
cut -f1 *.counts.txt | sort | uniq > todos_los_mirnas.txt

# 2. Crear la cabecera del archivo final
echo -n "miRNA" > matriz_final.txt
for f in *.counts.txt; do
    echo -ne "\t$(basename "$f" .counts.txt)" >> matriz_final.txt
done
echo "" >> matriz_final.txt

# 3. Rellenar la matriz
# Usamos un bucle que recorre la lista de miRNAs y busca en cada archivo
while read -r mirna; do
    echo -n "$mirna" >> matriz_final.txt
    for f in *.counts.txt; do
        # Buscamos el miRNA en el archivo. Si no existe, imprimimos 0
        valor=$(grep -w "$mirna" "$f" | cut -f2)
        echo -ne "\t${valor:-0}" >> matriz_final.txt
    done
    echo "" >> matriz_final.txt
done < todos_los_mirnas.txt

# Limpieza
rm todos_los_mirnas.txt

echo "Matriz generada: matriz_final.txt"
