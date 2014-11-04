#include <mips/regdef.h>
#include <sys/syscall.h>

.text
.align 2
.globl mips32_plot
.ent mips32_plot

#define STACK_SIZE 72

#define	A0 	72
#define	A1 	76
#define	A2 	80
#define A3 	84

#define RA  68
#define FP 	64

# void mips32_plot(param_t *parms)
mips32_plot:
	.frame	$fp		,STACK_SIZE		,ra
	#Bloque para código PIC
	.set noreorder
	.cpload t9
	.set reorder
	#Creación de stack frame
	subu	sp		,sp		,STACK_SIZE
	#Directiva para código PIC
	.cprestore		24 
	# Guardo el ra y el fp
	sw		ra		, RA(sp)
	sw		$fp		, FP(sp)
	# Actualizo frame pointer con el stack pointer actual
	# De aquí en más de usa $fp en lugar de sp
	move	$fp		,sp
	# Guardo los argumentos
	sw		a0		, A0($fp)
	sw		a1		, A1($fp)
	sw		a2		, A2($fp)
	sw		a3		, A3($fp)

# Lectura de los parametros desde la estuctura parametro
parse_args:
	#TODO: Suponer que pasado este punto se tienen todos los parametros parseados y los necesarios en LTA
	
	#FD
	lw		a0		,A0($fp)
	lw		t0		,36(a0)		#Sumo el offset al puntero para obtener el FILE*
	lh		t1		,14(t0)			#Recupero el fd de la estructura FILE. Como es un short recupero un halfword
	sw		t1		,20($fp) #TODO: VER, guardo el "file pointer" (descriptor) en la LTA

	#SHADES
	lw		a0		,A0($fp)
	lw		t0		,32(a0)
	sw		t0		,24($fp) 

	#Y_RES
	lW		a0		,A0($fp)
	lw		t0		,28(a0)
	sw		t0		,28($fp) 

	#X_RES
	lW		a0		,A0($fp)
	lw		t0		,24(a0)
	sw		t0		,32($fp) 

	#D_IM
	lW		a0		,A0($fp)
	lw		t0		,20(a0)
	sw		t0		,36($fp) 

	#D_RE
	lW		a0		,A0($fp)
	lw		t0		,16(a0)
	sw		t0		,40($fp) 

	#LR_IM
	lW		a0		,A0($fp)
	lw		t0		,12(a0)
	sw		t0		,44($fp) 

	#LR_RE
	lW		a0		,A0($fp)
	lw		t0		, 8(a0)
	sw		t0		,48($fp) 

	#UL_IM
	lW		a0		,A0($fp)
	lw		t0		, 4(a0)
	sw		t0		,52($fp) 

	#UL_RE
	lW		a0		,A0($fp)
	lw		t0		, 0(a0)
	sw		t0		,56($fp) 


# Escritura del header del PGM
write_header:

	la		a1		,PGM #Print header
	lw		a0		,20($fp)
	li 		a2		,3
	li		v0		,SYS_write

	syscall
	blt     v0		,a2		, write_error
	bne		a3		,zero		,write_error

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

	la 		a1		,60($fp)
	lw 		a0		,20($fp)
	li 		a2		,4 		#Se imprimen 4 bytes
	li 		v0		,SYS_write

	syscall
	blt     v0		,a2		, write_error
	bne		a3		,zero		,write_error

	la 		a1		,ENDL
	lw 		a0		,20($fp)
	li 		a2		,1		#Se imprime el \n
	li 		v0		,SYS_write

	syscall
	blt     v0		,a2		, write_error
	bne		a3		,zero		,write_error
	
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

	la 		a1		,60($fp)
	lw 		a0		,20($fp)
	li 		a2		,4 		#Se imprimen 4 bytes
	li 		v0		,SYS_write

	syscall
	blt     v0		,a2		, write_error
	bne		a3		,zero		,write_error

	la 		a1		,ENDL
	lw 		a0		,20($fp)
	li 		a2		,1		#Se imprime el \n
	li 		v0		,SYS_write

	syscall
	blt     v0		,a2		, write_error
	bne		a3		,zero		,write_error

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

	la 		a1		,60($fp)
	lw 		a0		,20($fp)
	li 		a2		,4 		#Se imprimen 4 bytes
	li 		v0		,SYS_write

	syscall
	blt     v0		,a2		, write_error
	bne		a3		,zero		,write_error

# Ciclo para recorrer todos los puntos
	#for (y = 0, ci = parms->UL_im; 
	li 		t8		,0  	#	y = 0
	sw 		t8		,16($fp)
	l.s 	$f26	,52($fp)#	CI

plot_loop_y:

	#y < parms->y_res; 
	lw		t0		,28($fp)
	lw      t8		,16($fp)
	beq		t0		,t8		,end_plot_loop_y

	#for (x = 0, cr = parms->UL_re; 
	li 		t9		,0 		#  x = 0
	sw   	t9		,12($fp)
	l.s 	$f24	,56($fp)#  CR

plot_loop_x:

	#x < parms->x_res; 
	lw		t0		,32($fp)
	lw 		t9		,12($fp)
	beq		t0		,t9		,end_plot_loop_x



# Ciclo para calcular el brillo de un punto
	lw 		t0		,24($fp)

	#zr = cr;
	#zi = ci;

	mov.s 	$f28	,$f24 #zr
	mov.s 	$f30 	,$f26 #zi	


shining_loop:

	beq		t0		,zero 	,end_of_shining_loop

	mul.s 	$f2 	,$f28	,$f28 #zr*zr
 	mul.s 	$f4		,$f30 	,$f30 #zi*zi

	add.s 	$f6 	,$f2 	,$f4

	li.s  	$f0		,4.0
	c.lt.s 	$f0 	,$f6
	bc1t	end_of_shining_loop		#4 es menor que zr*zr+zi*zi


	li.s  	$f0		,-4.0
	c.lt.s 	$f6 	,$f0
	bc1t	end_of_shining_loop		#-4 es mayor que zr*zr+zi*zi


	#sr = (zr * zr * zr) - (3 * zi * zi * zr) + cr;
	mul.s 	$f8 	,$f2 	,$f28 #zr*zr*zr
	
	li.s 	$f10 	,-3.0
	mul.s 	$f10	,$f10	,$f4  #zi*zi*-3
	mul.s   $f10	,$f10 	,$f28 #-3*zi*zi*zr
	
	add.s 	$f8		,$f10	,$f8  #sr = zr * zr * zr - 3 * zi * zi * zr 
	add.s   $f8		,$f8	,$f24 #add cr

	#si = 3 * zr * zr * zi - zi * zi * zi + ci;
	mul.s 	$f12 	,$f4 	,$f30 #zi*zi*zi

	li.s 	$f14 	,3.0
	mul.s 	$f14	,$f14	,$f2  #zr*zr*3
	mul.s   $f14	,$f14	,$f30 #3*zr*zr*zi

	sub.s 	$f12	,$f14	,$f12
	add.s   $f12	,$f12	,$f26 #add ci

	#zr = sr;
	#zi = si;

	mov.s 	$f28	,$f8
	mov.s 	$f30 	,$f12

	subu	t0		,t0		,1
	b 		shining_loop

end_of_shining_loop:

# Imprime el brillo del pixel actual, tiene que estar guardado en la LTA
print_shining:
	move a0, t0

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

	la 		a1		,60($fp)
	lw 		a0		,20($fp)
	li 		a2		,4 		#Se imprimen 4 bytes
	li 		v0		,SYS_write

	syscall

	blt     v0		,a2		, write_error
	bne		a3		,zero		,write_error

	#++x, cr += parms->d_re) {
	lw 		t9		,12($fp)
	addiu	t9		,t9		,1 #x++
	sw 		t9		,12($fp)

	l.s		$f0		,40($fp)
	add.s	$f24	,$f24	,$f0
	b plot_loop_x


end_plot_loop_x:
	#++y, ci -= parms->d_im) {
	lw  	t8		,16($fp)
	addiu	t8		,t8		,1 #y++
	sw 		t8		,16($fp)
	
	l.s		$f0		,36($fp)
	add.s	$f26	,$f26	,$f0
	b plot_loop_y

end_plot_loop_y:
	
# Fin de la ejecucion de la funcion
end:
	# Recupero ra y fp del stack
	lw		ra		,RA($fp)
	lw		$fp		,FP($fp)
	# Recupero los argumentos originales del stack
	lw		a0		,A0(sp)
	lw		a1		,A1(sp)
	lw		a2		,A2(sp)
	lw		a3		,A3(sp)
	# "Destruyo" el area de stack
	addu	sp		,sp		,STACK_SIZE

	# Retorno a la funcion que llamo
	jr		ra

# Manejo de errores de escritura
write_error:
	#TODO: Imprimir el error de escritura en stderr
	la		a1		,error
	li		a0		,2
	li		a2		,10		#Se imprimen 4 bytes
	li		v0		,SYS_write
	syscall

	la		a0		,1
	li		v0		,SYS_exit
	syscall


.end mips32_plot

.data

PGM:	.asciiz "P2\n"
DEBUG:	.asciiz "DEBUG\n"
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

error: .asciiz "I/O Error\n"
