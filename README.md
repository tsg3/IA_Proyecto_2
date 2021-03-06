# Inteligencia Artificial - Sistema Experto en Teoría Musical

## Descripción

Sistema experto en teoría musical básica. El sistema responde a solicitudes de información muy básicas sobre teoría musical básica, como por ejemplo intervalos, escalas mayores y acordes. El sistema está basado en reglas para el framework CLIPS.

Las funcionalidades que el sistema posee son las siguientes:

1. Cálculo de la frecuencia de una nota musical.
2. Cálculo del intervalo correspondiente entre dos notas musicales.
3. Cálculo de la nota encontrada al aumentar o disminuir una nota musical por un intervalo dado.
4. Cálculo de escalas musicales mayores.
5. Cálculo de progresiones circulares mayores.

## Requerimientos

- CLIPS

## Ejecución

- Descargar el código suministrado en el repositorio de GitHub.
- Descomprimir el paquete descargado.
- Una vez situado en la carpeta descomprimida, ejecutar el siguiente comando:

    {ruta al ejecutable de clips} -f2 batch.clp

- En caso de añadir del ejecutable de CLIPS a la variable PATH de Windows o en el directorio "/usr/bin" de Linux, se puede usar el siguiente comando:

    clips -f2 batch.clp
