#!/bin/bash

# Este script procesa todos los archivos .fq en el directorio actual
# Requisito: Tenerbowtie, samtools y el índice 'all_miRNAs' preparados.
input_dir="../02_clean"

for file in "$input_dir"/*.cleaned.polyAtrimmed.fq; do
    # Extraer el nombre base del archivo (sin la extensión .fq)
    base=$(basename "$file" .cleaned.polyAtrimmed.fq)

    echo "Procesando: $base..."

    # 1. Alineamiento con Bowtie
    bowtie db_know_novel_def --best -v 2 -q "$file" -S "${base}.sam"

    # 2. Conversión a BAM, ordenado y creación de índice
    samtools view -bS "${base}.sam" | samtools sort -o "${base}.bam" -O bam -
    samtools index "${base}.bam"

    # 3. Generación de conteos
    samtools idxstats "${base}.bam" | cut -f 1,3 > "${base}.counts.txt"

    # Opcional: Eliminar el archivo .sam para ahorrar espacio
    rm "${base}.sam"

    echo "Finalizado: $base"
done

echo "¡Todos los archivos han sido procesados correctamente!"
