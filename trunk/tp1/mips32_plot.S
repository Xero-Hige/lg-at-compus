#include <mips/regdef.h>
#include <sys/syscall.h>

.text
.align 2
.globl mips32_plot
.ent mips32_plot

# void mips32_plot(param_t *parms)
mips32_plot:
	.frame	$fp		,64		,ra #TODO: Probablemente se requiera mas para guardar los floating point regs
	#Bloque para código PIC
	.set noreorder
	.cpload t9
	.set reorder
	#Creación de stack frame
	subu	sp		,sp		,64
	#Directiva para código PIC
	.cprestore		24 
	# Guardo el ra y el fp
	sw		ra		, 64(sp)
	sw		$fp		, 60(sp)
	# Actualizo frame pointer con el stack pointer actual
	# De aquí en más de usa $fp en lugar de sp
	move	$fp		,sp
	# Guardo los argumentos
	sw		a0		, 4($fp)
	sw		a1		, 8($fp)
	sw		a2		, 12($fp)
	sw		a3		, 16($fp)

# Lectura de los parametros desde la estuctura parametro
parse_args:
	#TODO: Suponer que pasado este punto se tienen todos los parametros parseados y los necesarios en LTA
	
	#FD
	lw		a0		, 4($fp)
	addiu	t0		,a0		,36		#Sumo el offset al puntero para obtener el FILE*
	lhu		t0		,14(t0)			#Recupero el fd de la estructura FILE. Como es un short recupero un halfword
	sw		t0		,20($fp) #TODO: VER, guardo el "file pointer" (descriptor) en la LTA

	#la      a0,print
	#move  	a1,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9


	#SHADES
	lw		a0		, 4($fp)
	lw		t0		,32(a0)
	sw		t0		,24($fp) 

	#la      a0		,print
	#move  	a1		,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9

	#Y_RES
	lW		a0		, 4($fp)
	lw		t0		,28(a0)
	sw		t0		,28($fp) 

	#la      a0		,print
	#addu  	a1,zero,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9

	#X_RES
	lW		a0		, 4($fp)
	lw		t0		,24(a0)
	sw		t0		,32($fp) 

	#la      a0,print
	#addu  	a1,zero,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9

	#D_IM
	lW		a0		, 4($fp)
	lw		t0		,20(a0)
	sw		t0		,36($fp) 

	#la      a0,print_f
	#addu  	a1,zero,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9

	#D_RE
	lW		a0		, 4($fp)
	lw		t0		,16(a0)
	sw		t0		,40($fp) 

	#la      a0,print_f
	#lw    	a1		,0(t0)		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9

	#LR_IM
	lW		a0		, 4($fp)
	lw		t0		,12(a0)
	sw		t0		,44($fp) 

	#la      a0,print_f
	#addu  	a1,zero,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9

	#LR_RE
	lW		a0		, 4($fp)
	lw		t0		, 8(a0)
	sw		t0		,48($fp) 

	#la      a0,print_f
	#addu  	a1,zero,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9

	#UL_IM
	lW		a0		, 4($fp)
	lw		t0		, 4(a0)
	sw		t0		,52($fp) 

	#la      a0,print_f
	#addu  	a1,zero,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9

	#UL_RE
	lW		a0		, 4($fp)
	lw		t0		, 0(a0)
	sw		t0		,56($fp) 

	#la      a0,print_f
	#addu  	a1,zero,t0		
	#lw      t9,%call16(printf)(gp)
	#jalr    t9


# Escritura del header del PGM
write_header:

	la		a0		,PGM #Print header
	lw		a1		,20($fp)
	li 		a2		,3
	li		v0		,SYS_write

	syscall

	#X resolution

	lw 		a0		,32($fp)

	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,63($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,62($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,61($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,60($fp)

	la 		a0		,60($fp)
	lw 		a1		,20($fp)
	li 		a2		,4 		#Se imprimen 4 bytes
	li 		v0		,SYS_write

	syscall

	la 		a0		,ENDL
	lw 		a1		,20($fp)
	li 		a2		,1		#Se imprime el \n
	li 		v0		,SYS_write

	syscall
	 		
	#Y resolution

	lw 		a0		,28($fp)

	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,63($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,62($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,61($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,60($fp)

	la 		a0		,60($fp)
	lw 		a1		,20($fp)
	li 		a2		,4 		#Se imprimen 4 bytes
	li 		v0		,SYS_write

	syscall

	la 		a0		,ENDL
	lw 		a1		,20($fp)
	li 		a2		,1		#Se imprime el \n
	li 		v0		,SYS_write

	syscall

shades:
	lw 		a0		,24($fp)

	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,62($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,61($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,60($fp)

	li 		t0		,10 # \n
	sb 		t0		,63($fp)

	la 		a0		,60($fp)
	lw 		a1		,20($fp)
	li 		a2		,4 		#Se imprimen 4 bytes
	li 		v0		,SYS_write

	syscall

# Ciclo para recorrer todos los puntos
plot_loop:

# Ciclo para calcular el brillo de un punto
	lw 		t0		,24($fp)

	#TODO: Cambiar
	li.s 	$f28	,1.0 #zr
	li.s 	$f30 	,1.0 #zi	


shining_loop:
	beq		t0		,zero 	,end_of_shining_loop

	li.s  	$f0		,4.0
	mul.s 	$f2 	,$f28	,$f28 #zr*zr
 	mul.s 	$f4		,$f30 	,$f30 #zi*zi

	add.s 	$f6 	,$f2 	,$f4
	c.eq.s 	$f0 	,$f6
	bc1t	end_of_shining_loop 	

	mul.s 	$f8 	,$f2 	,$f28 #zr*zr*zr
	li.s 	$f10 	,-3.0
	mul.s 	$f10	,$f10	,$f4  #zi*zi*-3
	mul.s   $f10	,$f10 	,$f28 #-3*zi*zi*zr
	add.s 	$f8		,$f10	,$f8
	#falta add cr

	mul.s 	$f12 	,$f2 	,$f30 #zr*zr*zr
	li.s 	$f14 	,-3.0
	mul.s 	$f14	,$f14	,$f2  #zi*zi*-3
	mul.s   $f14	,$f14	,$f30 #-3*zi*zi*zr
	add.s 	$f12	,$f14	,$f12
	#falta add ci
	
	li.s 	$f16 	,0.0
	add.s 	$f28	,$f16	,$f8
	add.s 	$f30 	,$f16	,$f12

	subu	t0		,t0		,1
	b 		shining_loop

end_of_shining_loop:

# Imprime el brillo del pixel actual, tiene que estar guardado en la LTA
print_shining:
	lw 		a0		,24($fp) #TODO: estoy usando el brillo maximo

	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,62($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,61($fp)

	div 	a0		,a0		,10
	rem		t0		,a0		,10
	addiu	t0		,t0		,48
	sb 		t0 		,60($fp)

	li 		t0		,32 # Espacio
	sb 		t0		,63($fp)

	la 		a0		,60($fp)
	lw 		a1		,20($fp)
	li 		a2		,4 		#Se imprimen 4 bytes
	li 		v0		,SYS_write

	syscall

end_of_plot_loop:


# Fin de la ejecucion de la funcion
end:
	# Recupero ra y fp del stack
	lw		ra		,64($fp)
	lw		$fp		,60($fp)
	# Recupero los argumentos originales del stack
	lw		a0		, 4(sp)
	lw		a1		, 8(sp)
	lw		a2		,12(sp)
	lw		a3		,16(sp)
	# "Destruyo" el area de stack
	addu	sp		,sp		,64

	# Retorno a la funcion que llamo
	jr		ra

# Manejo de errores de escritura
write_error:
	#TODO: Imprimir el error de escritura en stderr
	b		end

.end mips32_plot

.ent mystrlen
mystrlen:
	.frame $fp, 16, ra
	.set noreorder
	.cpload t9
	.set reorder
	subu sp, sp, 16
	.cprestore 0
	sw $fp, 4(sp)
	move $fp, sp

	#USO V0 para el resultado de mystrlen
	li v0, 0
mystrlen_loop:
	lb t0, 0(a0)
	beqz t0, mystrlen_return
	addiu a0, a0, 1
	addiu v0, v0, 1
	j mystrlen_loop
mystrlen_return:
	#Destruimos el frame
	lw $fp, 4(sp)
	addu sp, sp, 16
	#retorno
	j ra
	.end mystrlen


.data

PGM:	.asciiz "P2\n"
ENDL:	.asciiz "\n"


FP:		.asciiz	"fp"
X_RES:	.asciiz	"x_res"
Y_RES:	.asciiz	"y_res"
SHADES:	.asciiz	"shades"

UL_RE:	.asciiz	"UL_re"
UL_IM:	.asciiz	"UL_im"
LR_RE:	.asciiz	"LR_re"
LR_IM:	.asciiz	"LR_im"
D_RE:	.asciiz	"d_re"
D_IM:	.asciiz	"d_im"

print:      .asciiz "The value is: %d\n"
print_f:      .asciiz "The value is: %f\n"

numbers: 
		.word number_0, number_1, number_2, number_3, number_4, number_5, number_6, number_7, number_8, number_9
		.size number, 40

number_0: .asciiz "0"
number_1: .asciiz "1"
number_2: .asciiz "2"
number_3: .asciiz "3"
number_4: .asciiz "4"
number_5: .asciiz "5"
number_6: .asciiz "6"
number_7: .asciiz "7"
number_8: .asciiz "8"
number_9: .asciiz "9"

#PRINT VALUE SNIPPET
#	la      a0,print
#	move    a1,t0
#	lw      t9,%call16(printf)(gp)
#	jalr    t9
