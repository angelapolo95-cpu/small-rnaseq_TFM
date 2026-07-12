# Pipeline de Análisis de Small RNA-seq (TFM)

Este repositorio contiene la metodología y los scripts utilizados para el procesamiento, identificación y cuantificación de datos de *small RNA-seq* (incluyendo miRNAs conocidos y predicción de nuevos miRNAs) en el contexto de mi Trabajo de Fin de Máster (TFM). Pipeline basado en el descrito por Garg et al. 2022 con ciertas modificaciones. 

## Descripción de la Metodología
El análisis se ha estructurado en un flujo de trabajo de bioinformática personalizada mediante scripts de Bash, organizado en las siguientes fases:

1. **Pre-procesamiento:**
   - Limpieza de adaptadores con `Trimmomatic` y `Cutadapt`.
   - Conversión de formato FASTQ a FASTA y colapso de lecturas redundantes con `fastx_collapser`.
   
2. **Filtrado de contaminantes:**
   - Eliminación de rRNA, tRNA, snRNA y snoRNA mediante alineamiento secuencial con `Bowtie` contra bases de datos de referencia (Rfam y secuencias repetitivas).

3. **Identificación de miRNAs:**
   - **Conocidos:** Mapeo contra `miRBase` utilizando `Bowtie`.
   - **Nuevos:** Predicción de miRNAs *de novo* utilizando `miRDeep2`, incluyendo la generación de índices genómicos personalizados.

4. **Cuantificación y Análisis:**
   - Generación de matrices de conteo mediante alineamiento final con `Bowtie` y procesamiento con `samtools`.
   - Automatización de la matriz de conteos final mediante scripts de Bash (`mapeos.sh` y `matriz_conteos.sh`).
   - Análisis de expresión diferencial (realizado en entorno R).

## Estructura del Repositorio
- `scripts/`: Contiene los archivos `.sh` con la lógica de procesamiento y cuantificación.
- `docs/`: (Opcional) Documentación adicional.
- `results/`: Directorio donde se almacenan los logs y resultados finales (matriz de conteos).

## Requisitos de Software
Para ejecutar este flujo, se requiere tener instaladas las siguientes herramientas en el entorno:
- `Trimmomatic`, `Cutadapt`, `Fastx-toolkit`
- `Bowtie` (v1.x)
- `miRDeep2`
- `Samtools`
- `R` (para el análisis de expresión diferencial)

## Uso
El análisis se realiza mediante la ejecución secuencial de los scripts presentes en la carpeta `scripts/`. 

*Nota: Asegúrese de ajustar las rutas a las bases de datos (`db/`) y a los archivos FASTQ de entrada en cada script antes de su ejecución.*

## Autor
**Ángela Polo**  
Trabajo de Fin de Máster (TFM)
