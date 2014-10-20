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
	lW		a0		, 4($fp)
	addiu	t0		,a0		,36		#Sumo el offset al puntero para obtener el FILE*
	lh		t0		,14(t0)			#Recupero el fd de la estructura FILE. Como es un short recupero un halfword
	sw		t0		,20($fp) #TODO: VER, guardo el "file pointer" (descriptor) en la LTA

	la      a0,print
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9


	#SHADES
	lW		a0		, 4($fp)
	lw		t0		,32(a0)
	sw		t0		,24($fp) 

	la      a0		,print
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9

	#Y_RES
	lW		a0		, 4($fp)
	lw		t0		,28(a0)
	sw		t0		,28($fp) 

	la      a0		,print
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9

	#X_RES
	lW		a0		, 4($fp)
	lw		t0		,24(a0)
	sw		t0		,32($fp) 

	la      a0,print
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9

	#D_IM
	lW		a0		, 4($fp)
	lw		t0		,20(a0)
	sw		t0		,36($fp) 

	la      a0,print_f
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9

	#D_RE
	lW		a0		, 4($fp)
	lw		t0		,16(a0)
	sw		t0		,40($fp) 

	la      a0,print_f
	lw    	a1		,0(t0)		
	lw      t9,%call16(printf)(gp)
	jalr    t9

	#LR_IM
	lW		a0		, 4($fp)
	lw		t0		,12(a0)
	sw		t0		,44($fp) 

	la      a0,print_f
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9

	#LR_RE
	lW		a0		, 4($fp)
	lw		t0		, 8(a0)
	sw		t0		,48($fp) 

	la      a0,print_f
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9

	#UL_IM
	lW		a0		, 4($fp)
	lw		t0		, 4(a0)
	sw		t0		,52($fp) 

	la      a0,print_f
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9

	#UL_RE
	lW		a0		, 4($fp)
	lw		t0		, 0(a0)
	sw		t0		,56($fp) 

	la      a0,print_f
	addu  	a1,zero,t0		
	lw      t9,%call16(printf)(gp)
	jalr    t9


# Escritura del header del PGM
write_header:

	lw		a0		,20($fp)
	addiu	a1		,$fp	,24
	addiu	a2		,zero	,4
	li		v0		,15

	syscall
# Ciclo para recorrer todos los puntos
plot_loop:

# Ciclo para calcular el brillo de un punto
shining_loop:

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

.data

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


#PRINT VALUE SNIPPET
#	la      a0,print
#	move    a1,t0
#	lw      t9,%call16(printf)(gp)
#	jalr    t9
