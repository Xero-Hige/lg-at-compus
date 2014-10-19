#include <mips/regdef.h>
#include <sys/syscall.h>

.text
.align 2
.globl mips32_plot
.ent mips32_plot

# void mips32_plot(param_t *parms)
mips32_plot:
	.frame	$fp		,40		,ra #TODO: Probablemente se requiera mas para guardar los floating point regs
	subu	sp		,sp		,40
	.cprestore		24 
	# Guardo el ra y el fp
	sw		ra		,32(sp)
	sw		$fp		,28(sp)
	# Actualizo frame pointer con el stack pointer actual
	move	$fp		,sp
	# Guardo los argumentos
	sw		a0		, 4(sp)
	sw		a1		, 8(sp)
	sw		a2		,12(sp)
	sw		a3		,16(sp)

# Lectura de los parametros desde la estuctura parametro
parse_args:
	#TODO: Suponer que pasado este punto se tienen todos los parametros parseados y los necesarios en LTA
	
	#TODO: Checkear
	lW		a0		, 4(sp)
	la		a1		,FP
	#call offsetof
#	addu	t0		,v0		,a0		#Sumo el offset al puntero
#	lw		t0		,0(t0)
#	sw		t0		,24(sp) #TODO: VER, guardo el file pointer (descriptor) en la LTA

	lW		a0		, 4(sp)
	la		a1		,SHADES
	#call offsetof
#	addu	t0		,v0		,a0		#Sumo el offset al puntero
#	lw		t0		,0(t0)
#	sw		v0		,20(sp) #TODO: VER, guardo el contenido de shades



# Escritura del header del PGM
write_header:

# Ciclo para recorrer todos los puntos
plot_loop:

# Ciclo para calcular el brillo de un punto
shining_loop:

# Fin de la ejecucion de la funcion
end:
	# Recupero ra y fp del stack
	lw		ra		,32(sp)
	lw		$fp		,28(sp)
	# Recupero los argumentos originales del stack
	lw		a0		, 4(sp)
	lw		a1		, 8(sp)
	lw		a2		,12(sp)
	lw		a3		,16(sp)
	# "Destruyo" el area de stack
	addu	sp		,sp		,40

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
SHADES:	.asciiz	"shades

UL_RE:	.asciiz	"UL_re"
UL_IM:	.asciiz	"UL_im"
LR_RE:	.asciiz	"LR_re"
LR_IM:	.asciiz	"LR_im"
D_RE:	.asciiz	"d_re"
D_IM:	.asciiz	"d_im"

