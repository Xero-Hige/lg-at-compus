#include <mips/regdef.h>
#include <sys/syscall.h>

.text
.align 2
.globl mips32_plot
.ent mips32_plot

# void mips32_plot(param_t *parms)
mips32_plot:
	.frame	$fp		,40		,ra #TODO:Probablemente se requiera mas para guardar los floating point regs
	subu	sp		,sp		,40
	.cprestore		24 
	#Guardo el ra y el fp
	sw		ra		,32(sp)
	sw		$fp		,28(sp)
	#Actualizo frame pointer con el stack pointer actual
	move	$fp		,sp
	#Guardo los argumentos
	sw		a0		,40(fp)
	sw		a1		,36(fp)
	sw		a2		,32(fp)
	sw		a3		,28(fp)



# Ciclo para recorrer todos los puntos
plot_loop:


shining_loop:


end:
	#Recupero ra y fp del stack
	lw		ra		,32(sp)
	lw		$fp		,28(sp)
	#Recupero los argumentos originales del stack
	lw		a0		,40(fp)
	lw		a1		,36(fp)
	lw		a2		,32(fp)
	lw		a3		,28(fp)
	#"Destruyo" el area de stack
	addu	sp		,sp		,40

	#Retorno a la funcion que llamo
	jr		ra

.end mips32_plot



.data
