		.syntax		unified
		.cpu		cortex-m0
		.thumb
.extern 	debounce_init, debounce_tarea
.extern 	lectura_teclado,numero_combinacion_init,numero_combinacion
.extern 	gpio_init, led_set, delay
/****************************************/
/*	Defino variables en RAM				*/
/****************************************/
.section	.bss
.comm	estado_boton,4
.comm	combinacion,4
.comm	estado_combinacion,4
/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ PORTC_ODR,		0x4001100C	// .equ es similar a  #define
.equ GPIOC_CHR, 	0x40011004	// Puerto GPIOC
.equ RCC_APB2ENR, 	0x40021018	// Registros

.equ GPIOA_CRL,		0x40010800	// GPIOA - Port configuration register low
.equ GPIOA_ODR,		0x4001080C
.equ PORTA_IDR, 	0x40010808	// GPIOA - Port input data register

/*CONSTANTES DE TECLADO MATRICIAL*/
.equ TECLA_0,	0b1010111
.equ TECLA_1, 	0b1101110
.equ TECLA_2,	0b1011110
.equ TECLA_3,	0b0111110
.equ TECLA_4,	0b1101101
.equ TECLA_5,	0b1011101
.equ TECLA_6,	0b0111101
.equ TECLA_7, 	0b1101011
.equ TECLA_8, 	0b1011011
.equ TECLA_9, 	0b0111011
.equ TECLA_NUM,	0b0110111
.equ TECLA_AST,	0b1100111

.equ COMBINACION_SOFT, 1234

.equ LOOP_COMPARE, 	0x2ffff		// Demora por software.



		.section	.text
		.align		2
 		.global		main

/****************************************/
/*	Función main. Acá salta boot.s 		*/
/*	cuando termina.						*/
/*	main NO TIENE QUE TERMINAR NUNCA	*/
/****************************************/
		.type		main, %function
main:

		BL		gpio_init
		BL 		numero_combinacion_init

		MOVS	R0,#0
		BL		led_set
main_loop:
		BL 		lectura_teclado
		BL 		debounce_tarea
		BL 		numero_combinacion

		//Demora*8
		LDR		R0,=#LOOP_COMPARE*8
		BL		delay

		LDR 	R1,=combinacion
		LDR 	R1,[R1] 				// cargo en R1 el contenido de R1 (combinacion)
		LDR 	R2,=#COMBINACION_SOFT	//if !(combinacion == COMBINACION_SOFT)
		CMP 	R1,R2
		BNE 	main_loop				//salto a main_loop

for_ever:								//if combinacion == COMBINACION_SOFT -> prendo el led integrado
		MOVS	R0,#1
		BL		led_set
		B 		for_ever

.end
