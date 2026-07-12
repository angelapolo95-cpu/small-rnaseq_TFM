#!/bin/bash

echo "=== INICIANDO PIPELINE (PRUNUS ARMENIACA CV. STELLA): $(date) ==="

# ==========================================
# 3.1 PREPROCESAMIENTO Y FILTRADO DE CALIDAD
# ==========================================
for FILE in ../01_raw_data/*_R1_001.fastq.gz
do
	#Extraemos el nombre limpio (quitando la ruta y la extension)
	SAMPLE=$(basename "$FILE" _R1_001.fastq.gz)

    echo "--------------------------------------------"
    echo "Procesando muestra: $SAMPLE"
    echo "--------------------------------------------"
    
    echo "1. Filtrando calidad con Trimmomatic..."
    trimmomatic SE -threads 2 \
        ../01_raw_data/${SAMPLE}_R1_001.fastq.gz \
        02_clean/${SAMPLE}.cleaned.fq \
        ILLUMINACLIP:illumina.fa:2:30:10 SLIDINGWINDOW:10:20

    echo "2. Cortando Poly-A y restringiendo tamaño (18-34 nt) con Cutadapt..."
    cutadapt -a "A{20}" -m 18 -M 34 \
        -o 02_clean/${SAMPLE}.cleaned.polyAtrimmed.fq \
        02_clean/${SAMPLE}.cleaned.fq
done

echo "==========================================="
echo "3. Combinando lecturas limpias globales..."
echo "==========================================="
cat 02_clean/*.cleaned.polyAtrimmed.fq > 02_clean/combined_reads.fq

echo "4. Convirtiendo a FASTA y colapsando lecturas únicas (Unique Tags)..."
# Reemplazo bioinformático puro de fastx_collapser (más rápido y nativo)
cat 02_clean/combined_reads.fq | paste - - - - | sed 's/^@/>/g' | cut -f 1,2 | tr '\t' '\n' > 02_clean/combined_reads.fa
fastx_collapser -i combined_reads.fa -o unique_tags.fa
sed -i 's/-/_x/' unique_tags.fa

echo "5. Indexando y mapeando contra tu Rfam personalizado..."
bowtie-build ../db/rfam.fa ../db/rfam
bowtie ../db/rfam -f 02_clean/unique_tags.fa -S 02_clean/unique_tags.ncRNA.sam --un 02_clean/unique_tags.unaligned.ncRNA.fa

echo "6. Indexando y mapeando contra Repbase (Plantas)..."
bowtie-build ../db/repeats.fa ../db/repeats
bowtie ../db/repeats -f 02_clean/unique_tags.unaligned.ncRNA.fa -S 02_clean/unique_tags.unaligned.ncRNA.repeats.sam --un 02_clean/unique_tags.filtered.fa

