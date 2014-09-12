#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <stdbool.h>
#include <math.h>

#define MAX_ITERATIONS 20

/**
 * Devuelve la parte real de un numero complejo.
 * El primer parámetro es la parte real y el segundo es la imaginaria.
 * HARDCODE
 */
float getComplexPixelX(float pixelX, float pixelY) {
	return 200;
}

/**
 * Devuelve la parte imaginaria de un numero complejo.
 * El primer parámetro es la parte real y el segundo es la imaginaria.
 * HARDCODE
 */
float getComplexPixelY(float pixelX, float pixelY) {
	return 100;
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
	float initialComplexPixelX = getComplexPixelX(pixelX, pixelY);
	float initialComplexPixelY = getComplexPixelY(pixelX, pixelY);
	float varComplexPixelX = initialComplexPixelX;
	float varComplexPixelY = initialComplexPixelY;
	float previousComplexPixelX, previousComplexPixelY;
	int brightness;
	for (brightness = 0; brightness < MAX_ITERATIONS - 1; brightness++) {
		if (getAbsolute(varComplexPixelX, varComplexPixelY) < 2.0) {
			break;
		}
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

	long int widht = 4;
	long int height = 4;

	double pixels_widht = 600;
	double pixels_height = 400;

	double center_x = 0;
	double center_y = 0;

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

	double x_pixel_widht = (widht / pixels_widht);
	double y_pixel_widht = (height / pixels_height);

	double initial_x = center_x - (x_pixel_widht / 2);
	double initial_y = center_y - (y_pixel_widht / 2);

	for (int x = 0; x < pixels_widht; x++) {
		for (int y = 0; y < pixels_height; y++) {
			double pos_x = initial_x + (x_pixel_widht * x);
			double pos_y = initial_y + (y_pixel_widht * y);
			printf("%f+%f i (%d)\n", pos_x, pos_y, getBrightness(pos_x, pos_y));
		}

	}

}
