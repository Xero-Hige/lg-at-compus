all:
	gcc -Wall -Wextra --pedantic --std=c99 ./tp.c -o ./tp -lm

clean:
	rm tp *.o
	
	
				double x_pixel_widht = (widht / pixels_widht);
				double y_pixel_widht = (height / pixels_height);

				double initial_x = center_x - (x_pixel_widht / 2);
				double initial_y = center_y - (y_pixel_widht / 2);

				for (int x = 0; x < pixels_widht; x++) {
					for (int y = 0; x < pixels_height; y++) {
						double pos_x = initial_x + (x_pixel_widht * x);
						double pos_y = initial_y + (y_pixel_widht * y);
						printf("%d+%d i (%d)\n", x, y,
								getBrightness(pos_x, pos_y));
					}

				}