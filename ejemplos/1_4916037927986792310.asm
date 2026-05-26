.data
	salto: .asciiz "\n"
	suma_men: .asciiz "La suma es: "
	resta_men: .asciiz "La resta es: "
	multiplicacion_men: .asciiz"La multiplicacion es: "
	division_men: .asciiz"DIV es: "
	mod_men: .asciiz "MOD es: "
	men1: .asciiz "Ingrese un numero: "
	men2: .asciiz "Ingrese otro numero: "
	fin: .asciiz "Fin del programa: "
	menu: .asciiz "Menu: \n 0)Salir \n 1)Suma \n 2)Resta \n 3)Multiplicacion \n 4)Div y Mod \n 5)Ingresar nuevos numeros \n Ingrese la opcion: "
.text
	main:	
			# 1)
	li $v0,4	#INDICO QUE MOSTRARE UN STRING POR PANTALLA
	la $a0,men1	#CARGO EL MENSAJE EN A0
	syscall		#IMPRIME
	
	li $v0,5	#INDICO PARA CAPTURAR ENTERO
	syscall		#CAPTURA
	move $t0,$v0	#MUEVO MI VARIABLE DE V0 A T0
	
	li $v0,4	#---------------------------------#
	la $a0,men2	#	IGUAL PASO ANTERIOR	  #
	syscall		#---------------------------------#
	
	li $v0,5	#---------------------------------#
	syscall		#	IGUAL PASO ANTERIOR	  #
	move $t1,$v0	#---------------------------------#
	
	jal saltolinea	#IMPRIMO SALTO DE LINEA
	
	while:			#FUNCION LLAMADA WHILE OPERA COMO UN MENU INTERACTIVO 
		li $v0,4	#INDICO QUE MOSTRARE UN STRING 
		la $a0,menu	#MOSTRAR MENSAJE DEL MENU
		syscall		#IMPRIME
	
		li $v0,5	#CAPTURO ENTERO
		syscall		#EJECUTO
		move $t2,$v0	#PASO V0 A T2
		
		jal saltolinea	#SALTO DE LINEA
					#EN T2 ESTA ALMACENADO LA OPCION DEL USUATIO
		beq $t2,0,salida	#SI T2 = 0 , VA A FUNC SALIDA
		beq $t2,1,suma		#SI T2 = 1 , SUMA
		beq $t2,2,resta		#SI T2 = 2, RESTA
		beq $t2,3,multi		#SI T2 = 3, MULTIPLICA
		beq $t2,4,divide	#SI T2 = 4, DIVIDE
		beq $t2,5,nuevaentrada	#SI T2 = 5, DA NUEVA ENTRADA DE DATOS
	
	j while				#FIN DE LA FUNCION WHILE
		
	suma:				#FUNCION SUMA
		li $v0,4		#INDICO QUE MOSTRARE UN STRING
		la $a0,suma_men		#CARGO MENSAJE
		syscall			#IMPRIME
		
		li $v0,1		#INDICO QUE MOSTRARE ENTERO
		add $a0,$t0,$t1		#SE REALIZA LA SUMA QUE SE CARGA EN A0, QUE SERA MOSTRADA
		syscall			#IMPRIME RESULTADO ALMACENADO EN A0
		
		jal saltolinea
		jal saltolinea
	j while				#REDIRIGE AL MENU
	
	resta:				#FUNCION RESTA
		li $v0,4		#INDICO QUE MOSTRARE ENTERO
		la $a0,resta_men	#CARGO MENSAJE
		syscall			#IMPRIME
		
		li $v0,1		#INDICO QUE MOSTRARE ENTERO
		sub $a0,$t0,$t1		#REALIZO LA RESTA Y SE CARGA EN A0
		syscall			#IMPRIMO RESULTADO	
		
		jal saltolinea
		jal saltolinea	
	j while				#REDIGIRE AL MENU	
	
	multi:				#FUNCION MULTIPLICACION
		li $v0,4			#INDICO QUE MOSTRARE STRING
		la $a0,multiplicacion_men	#CARGO MENSAJE
		syscall				#IMPRIMO
		
		li $v0,1		#INDICO QUE MOSTRARE ENTERO
		mul $a0,$t0,$t1		#REALIZO LA OPERACION Y SE CARGA EN A0
		syscall			#IMPRIMO RESULTADO
		
		jal saltolinea
		jal saltolinea
	j while				#REDIRIGE AL MENU
	
	divide:				#FUNCION DIVISION
		li $v0,4		#INDICO QUE MOSTRARE STRING
		la $a0,division_men	#CARGO MENSAJE
		syscall			#IMRPRIMO
		
		li $v0,1		#INDICO QUE MOSTRARE ENTERO
		div $a0,$t0,$t1		#REALIZO LA OPERACION Y SE CARGA LA PARTE ENTERA EN A0
		syscall			#IMPRIMO RESULTADO
		jal saltolinea
		
		mfhi $t7		#FUNCION PARA OBTENER EL MOD Y SE ALMACENA EN T7
		
		li $v0,4		#INDICO QUE MOSTRARE MENSAJE
		la $a0,mod_men		#CARGO MENSAJE
		syscall			#IMPRIMO
		
		li $v0,1		#INDICO QUE MOSTRARE ENTERO
		move $a0,$t7		#MUEVO DE T7 EL VALOR A A0
		syscall			#IMPRIMO EL RESULTADO
		
		jal saltolinea
		jal saltolinea
	j while				#REDIRIGE AL MENU
	
	nuevaentrada: 			#FUNCION PARA NUEVAS ENTRADAS
		li $v0,4
		la $a0,men1		
		syscall
	
		li $v0,5
		syscall
		move $t0,$v0
	
		li $v0,4
		la $a0,men2
		syscall
	
		li $v0,5
		syscall
		move $t1,$v0
	
		jal saltolinea
	jal while			#REDIRIGE AL MENU
	
	saltolinea:			#FUNCION SALTO DE LINEA
		
		li $v0,4		#INDICO QUE MOSTRARE STRING
		la $a0,salto		#CARGO MENSAJE
		syscall			#IMPRIMO
		
	jr $ra				#SALIDA ME DEVUELVE AL PUNTO DESDE EL CUAL FUE INVOCADO
	
	salida:				#FUNCION SALIDA
	
		li $v0,4		#INDICO QUE MOSTRARE STRING
		la $a0,fin		#CARGO MENSAJE
		syscall			#IMPRIMO
	
		li $v0,10		#INDICO QUE VOY A TERMINAR EL PROGRAMA
	syscall				#FIN DE PROGRAMA

