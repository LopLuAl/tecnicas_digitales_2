/*
 * conway.h
 *
 *  Created on: Jun 22, 2021
 *      Author: Luciano
 */

#ifndef INC_CONWAY_H_
#define INC_CONWAY_H_

#include "main.h"

#define MASCARA 0x000000FF
#define CANTIDAD_FILAS 8
#define CANTIDAD_POSICIONES 8
#define SEMILLA_LEGAJO 1593572

#define SUMA 0
#define RESTA 1

void      conway(uint8_t *actual, uint8_t *futuro);
uint8_t   indice (uint8_t indice,uint8_t operacion);
uint32_t  xor32(void);

uint8_t estado_actual[CANTIDAD_FILAS],estado_futuro[CANTIDAD_FILAS];
#endif /* INC_CONWAY_H_ */
