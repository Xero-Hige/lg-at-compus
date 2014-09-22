#include <getopt.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_ITERATIONS 256
#define WIDTH 4
#define HEIGHT 4
#define RESOLUTION_X 640
#define RESOLUTION_Y 480
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
	//printf("PIXEL X: %f - PIXEL Y: %f\n", x, y);
	double varComplexPixelX = x;
	double varComplexPixelY = y;
	double previousComplexPixelX, previousComplexPixelY;
	int brightness;
	double limitation = 2;
	//printf("COMPLEX_X: %f + COMPLEX_Y: %f\n", varComplexPixelX, varComplexPixelY);
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

int print_fractal(char* output_file) {
	FILE* output;

	if (strcmp("-", output_file) != 0) {
		output = fopen(output_file, "w");
	} else {
		output = stdout;
	}

	if (!output){
		fprintf(stderr,"fatal: cannot open output file.\n");
		return 3;
	}

	fprintf(output, "P2\n%d\n%d\n%d\n", resolutionX, resolutionY,
	MAX_ITERATIONS-1);
	double deltaX = width / resolutionX;
	double maxReal = centerReal + width / 2;
	double maxImaginary = centerImaginary + height / 2;
	double deltaY = height / resolutionY;
	int count_y = 0; //Cuenta iteraciones en y para que no superen el alto
	for (double y = centerImaginary - height / 2; y < maxImaginary; y +=
			deltaY) {

		if (count_y >= resolutionY)
			break;

		int count_x = 0; //Cuenta iteraciones en x para que no superen el ancho

		for (double x = centerReal - width / 2; x < maxReal; x += deltaX) {
			if (count_x >= resolutionX)
				break;
			fprintf(output, "%d ", getBrightness(x, y));
			count_x++;
		}

		fprintf(output, "\n");
		count_y++;
	}
	fclose(output);
	return 0;
}

bool parse_center(char* str_dimensions, double* real, double* imaginary) {
	char* end_ptr;

	*real = 1;

	if (str_dimensions[0] == '-') {
		str_dimensions++;
		*real = -1;
	}

	*real *= strtod(str_dimensions, &end_ptr);
	if (*end_ptr != '+' && *end_ptr != '-') {
		fprintf(stderr,"fatal: invalid center specification.\n");
		return false;
	}

	*imaginary = 1;

	if (*end_ptr == '+') {
		*imaginary = -1;
	}

	str_dimensions = end_ptr + 1;

	*imaginary *= strtod(str_dimensions, &end_ptr);
	if (*end_ptr != 'i') {
		fprintf(stderr,"fatal: invalid center specification.\n");
		return false;
	}

	return true;
}

bool parse_dimensions(char* str_dimensions, int* width, int* height) {
	char* end_ptr;

	*width = strtol(str_dimensions, &end_ptr, 10);
	if (*end_ptr != 'x') {
		printf("DEBUG: El primer parametro de r no es un numero\n");
		return false;
	}
	str_dimensions = end_ptr + 1;

	*height = strtol(str_dimensions, &end_ptr, 10);
	if (*end_ptr != 0) {
		printf("DEBUG: El segundo parametro de r no es un numero \n");
		return false;
	}

	if (*width <= 0 || *height <= 0) {
		printf("DEBUG: El parametro de r no es valido\n");
		return false;
	}

	return true;
}

int main(int argc, char **argv) {
	int c;
	char** end_ptr = NULL;

	char* output_file = "out.pgm";

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
			if (!parse_dimensions(optarg, &resolutionX, &resolutionY))
				return 2;
			break;

		case 'c':

			if (!parse_center(optarg, &centerReal, &centerImaginary))
				return 2;
			break;

		case 'w':
			width = strtod(optarg, end_ptr);
			if (end_ptr) {
				printf("fatal: width is not a valid number");
				return 2;
			}
			break;

		case 'H':
			height = strtod(optarg, end_ptr);
			if (end_ptr) {
				printf("fatal: height is not a valid number");
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

	return print_fractal(output_file);
}
