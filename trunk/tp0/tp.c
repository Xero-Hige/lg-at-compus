#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <stdbool.h>

/* Flag set by ‘--verbose’. */
static int verbose_flag;

int
main (int argc, char **argv)
{
	int c;

	long int widht = 4;
	long int height = 4;
	
	char a='a';
	char** end_ptr=NULL;  	

  while (true){
  	static struct option long_options[] =
  	{
  		/* These options set a flag. */
        {"resolution", required_argument, 0 , 'r'},
        {"center",   required_argument, 0 , 'c'},          
        {"width",    required_argument, 0 , 'w'},
        {"height",   required_argument, 0, 'H'},
        {"output",  required_argument, 0, 'o'},
        {"help",    no_argument, 0, 'h'},
        {0, 0, 0, 0}
    };
    int option_index = 0;
    c = getopt_long (argc, argv, "rcwHo:h:",
                       long_options, &option_index);

      /* Detect the end of the options. */
      if (c == -1)
        break;

      switch (c)
        {
        case 'r':
          puts ("option -r\n");
          
          break;

        case 'c':
          puts ("option -c\n");
          break;

        case 'w':
        	widht = strtol(optarg,end_ptr,10);
        	if (end_ptr){
        		printf("El parametro de w no es un numero");
        		return 2;
        	}
          printf ("option -w with value `%s'\n", optarg);
          break;

        case 'H':
          printf ("option -H with value `%s'\n", optarg);
          break;

        case 'f':
          printf ("option -f with value `%s'\n", optarg);
          break;

		case 'h':
			printf ("option -h\n");
			break;
        case '?':
        	break;

        default:
		   break;
        }
    }

  exit (0);
}
