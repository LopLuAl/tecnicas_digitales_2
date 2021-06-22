#include <stdio.h>
#include <stdlib.h>

#define MASCARA 0x000000FF
#define CANTIDAD_FILAS 8
#define CANTIDAD_POSICIONES 8
#define SEMILLA_LEGAJO 1593572

#define SUMA 0
#define RESTA 1




#define uint8_t unsigned int
#define uint32_t unsigned int

void      conway(uint8_t *actual, uint8_t *futuro);
uint8_t   indice (uint8_t indice,uint8_t operacion);
void      imprimir_matriz(uint8_t matriz);
uint32_t  xor32(void);

int main (void){
  uint8_t estado_actual[CANTIDAD_FILAS],estado_futuro[CANTIDAD_FILAS];
  uint8_t i,j;

  //Genero los8 estados con los 8 bits menos significativos con la semilla de mi legajo
  for (i=0;i<CANTIDAD_FILAS;i++)
    estado_actual[i] = xor32()&MASCARA;

  for (i=1;i<4;i++){
    printf("Tablero epoca: %d\n",i);
    for (j=0;j<CANTIDAD_FILAS;j++)
      imprimir_matriz(estado_actual[j]);
    printf("\n");
    conway(estado_actual,estado_futuro); // Le paso estado actual del tablero y me devuelve el estado futuro del tablero
  }
  return 0;
}
/*
~~~~~~~~~ REGLAS DE JUEGO ~~~~~~~~~
Una celda permanece viva en el siguiente estado si tiene dos o tres celdas vecinas vivas.
Una celda "nace" en el siguiente estado si tiene exactamente tres celdas vecinas vivas.
Toda celda que no cumple las condiciones anteriores muere (por "soledad" o "superpoblación") en el próximo estado.
*/
void conway(uint8_t *actual, uint8_t *futuro){
  uint8_t fila,posicion;
  uint8_t estado= 0;
  for(fila=0;fila<CANTIDAD_FILAS;fila++){
    futuro[fila] = actual[fila];
    for(posicion=0;posicion<CANTIDAD_POSICIONES;posicion++){
      /*
        Recorro las 8 posibles celdas activas al rededor de mi celda actual. Dependiendo del numero que sume,
        veo si se mantiene, muere o nace
      */
      estado = 0;
      if ((actual[fila]>>indice(posicion,SUMA))&0x01) // CELDA ACTUAL + 1 -> IGUAL FILA
         estado++;
      if ((actual[fila]>>indice(posicion,RESTA))&0x01) // CELDA ACTUAL - 1 -> IGUAL FILA
         estado++;
      if ((actual[indice(fila,SUMA)]>>posicion)&0x01)            //CELDA ACTUAL    -> SIGUIENTE FILA
         estado++;
      if ((actual[indice(fila,SUMA)]>>indice(posicion,SUMA))&0x01)//CELDA +1    -> SIGUIENTE FILA
         estado++;
      if ((actual[indice(fila,SUMA)]>>indice(posicion,RESTA))&0x01) //CELDA-1    -> SIGUIENTE FILA
         estado++;
      if ((actual[indice(fila,RESTA)]>>posicion)&0x01)               //CELDA ACTUAL    -> ANTERIOR FILA
         estado++;
      if ((actual[indice(fila,RESTA)]>>indice(posicion,SUMA))&0x01) //CELDA +1    -> ANTERIOR FILA
         estado++;
      if ((actual[indice(fila,RESTA)]>>indice(posicion,RESTA))&0x01) //CELDA -1    -> ANTERIOR FILA
         estado++;
      /*
      Una celda permanece viva en el siguiente estado si tiene dos o tres celdas
      vecinas vivas.
      */
      if(estado>=2&&estado<=3&&(actual[fila]>>posicion&0x01))
        futuro[fila]|=0x01<<posicion;
      /*
      Una celda "nace" en el siguiente estado si tiene exactamente tres celdas vecinas vivas.
      */
      else if (estado==3&&(!(actual[fila]>>posicion&0x01)))
          futuro[fila]|=0x01<<posicion;
      /*Toda celda que no cumple las condiciones anteriores muere
      (por "soledad" o "superpoblación") en el próximo estado.*/
      else
        futuro[fila]&=~(0x01<<posicion);
    }

  }
  for(fila=0;fila<CANTIDAD_FILAS;fila++)
    actual[fila] = futuro[fila];
}

uint8_t indice (uint8_t indice,uint8_t operacion){
  /*
   funcion para controlar que si hago 0-1 me de igual a 7 y no el ca2
   ya que estoy la hago  mas generica y hago todas las operaciones
  */
  if (indice == 0 && operacion == RESTA)
    return (CANTIDAD_POSICIONES-1);
  else  if (indice != 0 && operacion == RESTA)
    return indice-1;
  else if (operacion == SUMA && indice < (CANTIDAD_POSICIONES-1))
    return indice+1;
  else
    return 0;
}

void imprimir_matriz(uint8_t  matriz){
  int i;
  for(i=1;i<=CANTIDAD_POSICIONES;i++){

    printf("|");

    if( ((matriz>>(CANTIDAD_POSICIONES-i))&0x01) == 1)
      printf("*");
    else
      printf(" ");
  }
  printf("|\n");
}
uint32_t xor32(void) {
  static uint32_t y = SEMILLA_LEGAJO;
  y^= y<<13;
  y^= y>>17;
  y^= y<<5;
  return y;
}
