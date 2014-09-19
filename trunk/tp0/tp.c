#include <getopt.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ITERATIONS 256
#define WIDTH 4
#define HEIGHT 2
#define RESOLUTION_X 500
#define RESOLUTION_Y 200
#define CENTER_REAL 0
#define CENTER_IMAGINARY 0

static double width = WIDTH;
static double height = HEIGHT;
static int resolutionX = RESOLUTION_X;
static int resolutionY = RESOLUTION_Y;
static double centerReal = CENTER_REAL;
static double centerImaginary = CENTER_IMAGINARY;

/**
 * Devuelve el módulo de un numero complejo.
 * El primer parámetro es la parte real y el segundo es la imaginaria.
 */
double getAbsolute(double pixelX, double pixelY) {
	double real = pixelX * pixelX;
	double imaginary = pixelY * pixelY;
	return sqrt(real + imaginary);
}

/**
 * Trae la parte real de la nueva iteración. 
 */
double getNewIterationX(double pixelX, double pixelY, double initialPixelX) {
	return (pixelX * pixelX) - (pixelY * pixelY) + initialPixelX;
}

/**
 * Trae la parte imaginaria de la nueva iteración. 
 */
double getNewIterationY(double pixelX, double pixelY, double initialPixelY) {
	return 2 * (pixelX * pixelY) + initialPixelY;
}

/**
 * Devuelve el brillo de un pixel que se recibe por parámetro.
 */
int getBrightness(double x, double y) {
	printf("PIXEL X: %f - PIXEL Y: %f\n", x, y);
	double varComplexPixelX = x;
	double varComplexPixelY = y;
	double previousComplexPixelX, previousComplexPixelY;
	int brightness;
	double limitation = 2;
	printf("COMPLEX_X: %f + COMPLEX_Y: %f\n", varComplexPixelX, varComplexPixelY);
	for (brightness = 0; brightness < MAX_ITERATIONS - 1; brightness++) {
		if (getAbsolute(varComplexPixelX, varComplexPixelY) > limitation) {
			break;
		}
		previousComplexPixelX = varComplexPixelX;
		previousComplexPixelY = varComplexPixelY;
		varComplexPixelX = getNewIterationX(previousComplexPixelX,
				previousComplexPixelY, x);
		varComplexPixelY = getNewIterationY(previousComplexPixelX,
				previousComplexPixelY, y);
	}
	return brightness;
}

void print_fractal(char* output_file) {
	FILE* output;
	if (strcmp("-", output_file) != 0) {
		output = fopen(output_file, "w");
	} else {
		output = stdout;
	}
	fprintf(output, "P2\n%d %d\n%d\n", resolutionX, resolutionY,
			MAX_ITERATIONS);
	double deltaX = width / resolutionX;
	double maxReal = centerReal + width / 2;
	double maxImaginary = centerImaginary + height / 2;
	double deltaY = height / resolutionY;
	for (double y = centerImaginary - height / 2; y <= maxImaginary; y += deltaY) {
		for (double x = centerReal - width / 2; x <= maxReal; x += deltaX) {
			fprintf(output, "%d \n", getBrightness(x, y));
		}
		fprintf(output, "\n");
	}
	fclose(output);
}

int main(int argc, char **argv) {
	int c;
	char** end_ptr = NULL;

	char* output_file = "-";

	while (true) {
		static struct option long_options[] = {
				/* These options set a flag. */
				{ "resolution", required_argument, 0, 'r' }, { "center",
						required_argument, 0, 'c' }, { "width", required_argument, 0, 'w' }, {
								"height", required_argument, 0, 'H' }, { "output",
										required_argument, 0, 'o' }, { "help",
												no_argument, 0, 'h' }, { 0, 0, 0, 0 } };
		int option_index = 0;
		c = getopt_long(argc, argv, "r:c:w:H:o:h:", long_options,
				&option_index);
		/* Detect the end of the options. */
		if (c == -1)
			break;

		switch (c) {
		case 'r':
			puts("option -r\n");
			break;

		case 'c':
			puts("option -c\n");
			break;

		case 'w':
			width = strtod(optarg, end_ptr);
			if (end_ptr) {
				printf("DEBUG: El parametro de w no es un numero");
				return 2;
			}
			break;

		case 'H':
			height = strtod(optarg, end_ptr);
			if (end_ptr) {
				printf("DEBUG: El parametro de H no es un numero");
				return 2;
			}
			break;

		case 'o':
			output_file = optarg;
			break;

		case 'h':
			printf("option -h\n");
			break;

		case '?':
			break;

		default:
			break;
		}
	}

	print_fractal(output_file);
}
