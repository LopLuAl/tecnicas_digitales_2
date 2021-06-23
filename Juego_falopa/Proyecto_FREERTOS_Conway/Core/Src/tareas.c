#include "main.h"
void tarea_led(void *p)
{
	for(;;)
	{
		if( xSemaphoreTake( sem1, portMAX_DELAY ) == pdTRUE )
		{
			HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);
			xSemaphoreGive( sem1 );
			vTaskDelay(LED_TICKS/portTICK_RATE_MS);
		}


	}
}
void generar_estado_inicial (void *p){
	uint8_t i;
	for(;;){
		for (i=0;i<CANTIDAD_FILAS;i++)
			estado_actual[i] = xor32()&MASCARA;

		vTaskResume( (TaskHandle_t*)p );

		vTaskSuspend( NULL );

	}
}
void evolucionar_estado(void *p)
{
	for(;;){
		if( xSemaphoreTake( sem1, portMAX_DELAY ) == pdTRUE )
		{
			if( xSemaphoreTake( sem2, portMAX_DELAY ) == pdTRUE )
			{
				dibujar_max7219(estado_actual);
				conway(estado_actual, estado_futuro);
				xSemaphoreGive( sem1 );
				xSemaphoreGive( sem2 );
				vTaskDelay(LED_TICKS/portTICK_RATE_MS);
			}
		}
	}
}
void detectar_tablero_muerto(void *p){
	uint8_t i,cuenta;
	static uint8_t aux[CANTIDAD_FILAS];

	for(i=0;i<CANTIDAD_FILAS;i++)
		aux[i] = 0;

	for(;;){
		cuenta = 0;
		if( xSemaphoreTake( sem2, portMAX_DELAY ) == pdTRUE )
		{
			for (i=0;i<CANTIDAD_FILAS;i++)
			{
				if (estado_actual[i] == aux[i])
					cuenta ++;
			}
			for(i=0;i<CANTIDAD_FILAS;i++)
				aux[i] = estado_actual[i];
			if (cuenta == CANTIDAD_FILAS) // EL VECTOR ESTA VACIO Y TENGO QUE GENERAR UN NUEVO TABLERO!
				vTaskResume( (TaskHandle_t*)p ); //SI TENGO EL VECTOR VACIO
			xSemaphoreGive( sem2 );
			vTaskDelay(LED_TICKS/portTICK_RATE_MS); // Hago esta pasusa porque sino cuando mando a dormir a la tarea que muestra, esta tarea corre mas veces y aux y estado actual terminan valiendo lo mismo
		}

	}
}

