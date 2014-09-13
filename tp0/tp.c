#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <stdbool.h>
#include <math.h>

#define MAX_ITERATIONS 1000
#define WIDTH 4
#define HEIGHT 4
#define RESOLUTION_X 640
#define RESOLUTION_Y 480
#define CENTER_REAL 0
#define CENTER_IMAGINARY 0

float width = WIDTH;
float height = HEIGHT;
float resolutionX = RESOLUTION_X;
float resolutionY = RESOLUTION_Y;
float centerReal = CENTER_REAL;
float centerImaginary = CENTER_IMAGINARY;


/**
 * Devuelve la parte real de un numero complejo.
 * El parámetro es la parte real.
 */
float getComplexPixelX(int pixelX) {
	float complexResolution = width / resolutionX;
	float value = (centerReal - (width / 2)) + complexResolution * pixelX;
	//printf("CENTER REAL: %f - WIDTH: %f - COMPLEX_X: %f\n", centerReal, width, value);
	return value;
}

/**
 * Devuelve la parte imaginaria de un numero complejo.
 * El parámetro es la parte imaginaria.
 */
float getComplexPixelY(int pixelY) {
	float complexResolution = height / resolutionY;
	float value = (centerImaginary - (height / 2)) + complexResolution * pixelY;
	//printf("CENTER IMAGINARY: %f - HEIGHT: %f - COMPLEX_Y: %f\n", centerImaginary, height, value);
	return value;
}

/**
 * Devuelve el módulo de un numero complejo.
 * El primer parámetro es la parte real y el segundo es la imaginaria.
 */
float getAbsolute(float pixelX, float pixelY) {
	float real = pixelX * pixelX;
	float imaginary = pixelY * pixelY;
	return sqrt(real + imaginary);
}

/**
 * Trae la parte real de la nueva iteración. 
 */
float getNewIterationX(float pixelX, float pixelY, float initialPixelX) {
	return (pixelX * pixelX) - (pixelY * pixelY) + initialPixelX;
}

/**
 * Trae la parte imaginaria de la nueva iteración. 
 */
float getNewIterationY(float pixelX, float pixelY, float initialPixelY) {
	return (pixelX * pixelY) + (pixelX * pixelY) + initialPixelY;
}

/**
 * Devuelve el brillo de un pixel que se recibe por parámetro.
 */
int getBrightness(int pixelX, int pixelY) {
	//printf("PIXEL X: %i - PIXEL Y: %i\n", pixelX, pixelY);
	float initialComplexPixelX = getComplexPixelX(pixelX);
	float initialComplexPixelY = getComplexPixelY(pixelY);
	float varComplexPixelX = initialComplexPixelX;
	float varComplexPixelY = initialComplexPixelY;
	float previousComplexPixelX, previousComplexPixelY;
	int brightness;
	float limitation = 2;
	for (brightness = 0; brightness < MAX_ITERATIONS - 1; brightness++) {
		if (getAbsolute(varComplexPixelX, varComplexPixelY) > limitation) {
			break;
		}
		//printf("COMPLEX_X: %f - COMPLEX_Y: %f\n", varComplexPixelX, varComplexPixelY);
		previousComplexPixelX = varComplexPixelX;
		previousComplexPixelY = varComplexPixelY;
		varComplexPixelX = getNewIterationX(previousComplexPixelX,
				previousComplexPixelY, initialComplexPixelX);
		varComplexPixelY = getNewIterationY(previousComplexPixelX,
				previousComplexPixelY, initialComplexPixelY);
	}
	return brightness;
}

int main(int argc, char **argv) {
	int c;

	/**
	 char a = 'a';
	 char** end_ptr = NULL;

	 while (true) {
	 static struct option long_options[] = {*/
	/* These options set a flag. */
	/*{ "resolution", required_argument, 0, 'r' }, { "center",
	 required_argument, 0, 'c' }, { "width", required_argument, 0,
	 'w' }, { "height", required_argument, 0, 'H' }, { "output",
	 required_argument, 0, 'o' }, { "help", no_argument, 0, 'h' }, {
	 0, 0, 0, 0 } };
	 int option_index = 0;
	 c = getopt_long(argc, argv, "rcwHo:h:", long_options, &option_index);
	 */
	/* Detect the end of the options. */
	/*if (c == -1)
	 break;

	 switch (c) {
	 case 'r':
	 puts("option -r\n");

	 break;

	 case 'c':
	 puts("option -c\n");
	 break;

	 case 'w':
	 widht = strtol(optarg, end_ptr, 10);
	 if (end_ptr) {
	 printf("El parametro de w no es un numero");
	 return 2;
	 }
	 printf("option -w with value `%s'\n", optarg);
	 break;

	 case 'H':
	 printf("option -H with value `%s'\n", optarg);
	 break;

	 case 'f':
	 printf("option -f with value `%s'\n", optarg);
	 break;

	 case 'h':
	 printf("option -h\n");
	 break;
	 case '?':
	 break;

	 default:
	 break;
	 }
	 }*/

	for (int pixelX = 0; pixelX <= resolutionX; pixelX++) {
		for (int pixelY = 0; pixelY <= resolutionY; pixelY++) {
			printf("PIXEL X: %i, PIXEL Y: %i, BRILLO: %i\n", pixelX, pixelY, getBrightness(pixelX, pixelY));
		}
	}

}
