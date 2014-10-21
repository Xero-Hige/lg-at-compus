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

	#jal print_numbers

	#SHADES
	lw		a0		, 4($fp)
	lw		t0		,32(a0)
	sw		t0		,24($fp) 

	#jal print_numbers
	#Y_RES
	lW		a0		, 4($fp)
	lw		t0		,28(a0)
	sw		t0		,28($fp) 

	#jal print_numbers

	#X_RES
	lW		a0		, 4($fp)
	lw		t0		,24(a0)
	sw		t0		,32($fp) 

	#jal print_numbers

	#D_IM
	lW		a0		, 4($fp)
	lw		t0		,20(a0)
	sw		t0		,36($fp) 

	#jal print_numbers

	#D_RE
	lW		a0		, 4($fp)
	lw		t0		,16(a0)
	sw		t0		,40($fp) 

	#jal print_numbers

	#LR_IM
	lW		a0		, 4($fp)
	lw		t0		,12(a0)
	sw		t0		,44($fp) 

	#jal print_numbers

	#LR_RE
	lW		a0		, 4($fp)
	lw		t0		, 8(a0)
	sw		t0		,48($fp) 

	#jal print_numbers

	#UL_IM
	lW		a0		, 4($fp)
	lw		t0		, 4(a0)
	sw		t0		,52($fp) 

	#jal print_numbers

	#UL_RE
	lW		a0		, 4($fp)
	lw		t0		, 0(a0)
	sw		t0		,56($fp) 

	#jal print_numbers


# Escritura del header del PGM
write_header:

	la		a0		,PGM #Print header
	lw		a1		,20($fp)
	li 		a2		,3
	li		v0		,SYS_write

	syscall
	bne		a2		,a3		,write_error

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
	bne		a2		,a3		,write_error

	la 		a0		,ENDL
	lw 		a1		,20($fp)
	li 		a2		,1		#Se imprime el \n
	li 		v0		,SYS_write

	syscall
	bne		a2		,a3		,write_error

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
	bne		a2		,a3		,write_error

	la 		a0		,ENDL
	lw 		a1		,20($fp)
	li 		a2		,1		#Se imprime el \n
	li 		v0		,SYS_write

	syscall
	bne		a2		,a3		,write_error

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
	bne		a2		,a3		,write_error

# Ciclo para recorrer todos los puntos
	#for (y = 0, ci = parms->UL_im; 
	li 		t8		,0  	#	y = 0
	l.s 	$f26	,52($fp)#	CI

plot_loop_y:
	#y < parms->y_res; 
	lw		t0		,28($fp)
	beq		t0		,t8		,end_plot_loop_y

	#for (x = 0, cr = parms->UL_re; 
	li 		t9		,0 		#  x = 0
	l.s 	$f24	,56($fp)#  CR

plot_loop_x:
	#x < parms->x_res; 
	lw		t0		,32($fp)
	beq		t0		,t9		,end_plot_loop_x



# Ciclo para calcular el brillo de un punto
	lw 		t0		,24($fp)

	#zr = cr;
	#zi = ci;

	mov.s 	$f28	,$f24 #zr
	mov.s 	$f30 	,$f26 #zi	


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
	add.s   $f8		,$f8	,$f26 #add cr

	mul.s 	$f12 	,$f2 	,$f30 #zr*zr*zr
	li.s 	$f14 	,-3.0
	mul.s 	$f14	,$f14	,$f2  #zi*zi*-3
	mul.s   $f14	,$f14	,$f30 #-3*zi*zi*zr
	add.s 	$f12	,$f14	,$f12
	add.s   $f12	,$f12	,$f24 #add ci

	
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

	bne		a2		,a3		,write_error

	#++x, cr += parms->d_re) {
	addiu	t9		,t9		,1 #x++
	l.s		$f0		,40($fp)
	add.s	$f24	,$f24	,$f0
	b plot_loop_x


end_plot_loop_x:
	#++y, ci -= parms->d_im) {
	addiu	t8		,t8		,1 #y++
	l.s		$f0		,36($fp)
	add.s	$f26	,$f26	,$f0
	b plot_loop_y

end_plot_loop_y:
	


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
	la		a0		,error
	li		a1		,2
	li		a2		,10		#Se imprimen 4 bytes
	li		v0		,SYS_write
	syscall

	la		a0		,1
	li		v0		,SYS_exit
	syscall


.end mips32_plot

.ent print_numbers
print_numbers:
	# debugging info: descripcion del stack frame
	.frame	$fp, 40, ra	# $fp: registro usado como frame pointer
				# 40: tamañodel stack frame
				# ra: registro que almacena el return address
	# bloque para codigo PIC
	.set	noreorder	# apaga reordenamiento de instrucciones
	.cpload t9		# directiva usada para codigo PIC
	.set	reorder		# enciende reordenamiento de instrucciones

	# creo stack frame
	subu	sp, sp, 40	# 4 (SRA) + 2 (LTA) + 4 (ABA)

	# directiva para codigo PIC
	.cprestore 24		# inserta aqui "sw gp, 24(sp)",
				# mas "lw gp, 24(sp)" luego de cada jal.
	# salvado de callee-saved regs en SRA	
	sw	$fp, 28(sp)
	sw	ra, 32(sp)

	# de aqui al fin de la funcion uso $fp en lugar de sp.
	move	$fp, sp
	
	# salvo 1er arg (siempre)
	sw	a0, 40($fp)	# n: a0, sp+40

	# r = n % 10;
	remu	t0, a0, 10	# r: t0, sp+16	## remU
	sw	t0, 16($fp)

	# n /= 10;
	lw	a0, 40($fp)			## redundante
	divu	a0, a0, 10			## divU!
	sw	a0, 40($fp)

	## if (n > 0) 
	lw	a0, 40($fp)			## redundante
	beq	a0, zero, _write_numbers # n>0 equivale a n!=0 (n unsigned)
	
	#	print_numbers(n);
	lw	a0, 40($fp)			## redundante
	la	t9, print_numbers
	jal	ra, t9

_write_numbers:
	# write(1, numbers[r], mystrlen(numbers[r]));
	# calculo auxiliar: obtengo numbers[r]
	lw	a0, 16($fp)	# r: a0, sp+16
	sll	a0, a0, 2	# escalo r con tam de ptr (r*=4)
	lw	a0, numbers(a0)	# numbers[r]: a0
	sw	a0, 20($fp)	# almaceno numbers[r] en LTA
	# obtengo mystrlen(numbers[r])
	la	t9, mystrlen	# mystrlen(numbers[r])
	jal	ra, t9
	# cargo argumentos y nro de syscall
	move	a2, v0
	lw	a1, 20($fp)	# numbers[r] ## (por que no hago move a1, a0?)
	li	a0, 1	
	li	v0, SYS_write
	syscall

	# return;
	# restauro callee-saved regs
	lw	gp, 24(sp)
	lw	$fp, 28(sp)
	lw	ra, 32(sp)
	# destruyo stack frame
	addu	sp, sp, 40
	# vuelvo a funcion llamante
	jr	ra

	.end	print_numbers
	.size	print_numbers,.-print_numbers


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

error: .asciiz "I/O Error\n"

#PRINT VALUE SNIPPET
#	la      a0,print
#	move    a1,t0
#	lw      t9,%call16(printf)(gp)
#	jalr    t9
