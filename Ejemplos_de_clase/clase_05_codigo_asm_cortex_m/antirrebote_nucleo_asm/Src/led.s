		.syntax		unified
		.cpu		cortex-m0
		.thumb

/****************************************/
/*	Defino Rutinas Externas				*/
/****************************************/
	.extern		board_init, led_set, led_reset, b1_read
	.extern 	dwt_init, dwt_reset, dwt_read
	.extern 	debounce_init, debounce_tarea

/****************************************/
/*	Defino variables en RAM				*/
/****************************************/
	.section	.bss
	.comm	tics_led	,4
	.comm	estado_led	,4
	.comm	estado_boton,4

/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ LED_TICK,		250
.equ ESPERA_1MS,	5333	//Supongo CLK=16MHz


/****************************************/
/*	Función main. Acá salta boot.s 		*/
/*	cuando termina.						*/
/*	main NO TIENE QUE TERMINAR NUNCA	*/
/****************************************/
		.section	.text
		.align		2
 		.global		main
		.type		main, %function
main:
		/**********************/
		/* Inicialización 	  */
		/*	-contador dwt	  */
		/*	-led y pulsador	  */
		/*  -fsm antirrebote  */
		/*	-tics_led=LED_TICK*/
		/*  -estado_led=0     */
		/**********************/
		BL		dwt_init
		BL		board_init
		BL		debounce_init
		LDR		R0,=#LED_TICK
		LDR		R1,=tics_led
		STR		R0,[R1]
		MOVS	R0,#0
		LDR		R1,=estado_led
		STR		R0,[R1]
main_loop:
		BL		b1_read				//Leo el pulsador.
		BL		debounce_tarea		//FSM Antirrebote
		LDR		R1,=estado_boton	//Devuelve estado en R0
		STR		R0,[R1]				//Estado del pulsador.

		LDR		R1,=tics_led		//Como main_loop se ejecuta
		LDR		R0,[R1]				//(aproximadamente) cada 1ms
		SUBS	R0,#1				//decremento tics_led en casa
		CMP		R0,#0				//pasada y cuenta vale 0, recargo
		BNE		main_actualiza_led	//e intento ejecutar toggle_led
		LDR		R0,=#LED_TICK		//if(!--tics_led) {
		LDR		R2,=estado_boton	//  tics_led = LED_TICK;
		LDR		R3,[R2]				//  if(!estado_boton)
		CMP		R3,#0				//    toggle_led();
		BNE		main_actualiza_led	//}
		BL		toggle_led			//Invierto estado del led.
main_actualiza_led:					//
		STR		R0,[R1]				//guarda tics_led en memoria RAM


		/**********************/
		/* Demora de 1ms 	  */
		/* antes de volver a  */
		/* ejecutar main_loop */
		/**********************/
		LDR		R1,=#ESPERA_1MS
main_espera_1ms:
		SUBS	R1,#1
		BNE		main_espera_1ms
		B		main_loop


/****************************************/
/*	Función invierte el estado del led. */
/*	guarda en estado_led el valor que 	*/
/*	después usa para invertir			*/
/*										*/
/****************************************/
.type		toggle_led, %function
toggle_led:
		PUSH	{R0, R1, R2, LR}
		MOVS	R2,#1
		LDR		R1,=estado_led
		LDR		R0,[R1]
		EORS	R0,R0,R2
		STR		R0,[R1]
		CMP		R0,#0
		BEQ		toggle_led_cero
		BL		led_set
		B		toggle_led_sale
toggle_led_cero:
		BL		led_reset
toggle_led_sale:
		POP		{R0, R1, R2, PC}
.end
