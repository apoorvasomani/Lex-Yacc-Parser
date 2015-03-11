%{
#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>
FILE *yyin;
#define YYSTYPE int
typedef void* yyscan_t;
typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern int yylex();
extern int yylex_init(void *);
extern int yyset_in(FILE*,yyscan_t);
extern int yylex_destroy(void *);
%}
%pure-parser
%token digit
%lex-param {void* yyscan_t}
%parse-param {void* yyscan_t}
%start list
%token NUMBER
%left '+' '-'
%left '*' '/' '%'
%left UMINUS 
%union {int i;}
%%

list:	                   
        |
        list stat '\n'
        |
        list error '\n'{ yyerrok; }
        ;

stat:   expr { printf("Thread = %ld ... Ans = %d\n",pthread_self(),$1);}
        ;

expr:   '(' expr ')'{ $$ = $2; }
        |
        expr '*' expr { $$ = $1 * $3; }
        |
        expr '/' expr { $$ = $1 / $3; }
        |
        expr '+' expr { $$ = $1 + $3; }
        |
        expr '-' expr { $$ = $1 - $3; }
        |
        '-' expr %prec UMINUS { $$ = -$2; }
	    |
	    NUMBER
        ;
        
%%

struct struct_arg
{
    unsigned char* file;
    yyscan_t s;
};

int yyerror()
{
    return 1;
}

void *parse(void *arguments)
{
  struct struct_arg *args = (struct struct_arg *)arguments;
  unsigned char* filename;
  filename = args -> file;
  yyscan_t s;

  FILE *file_pointer;
  file_pointer = fopen((const char*)filename, "r");
  yylex_init(&s);
  yyset_in((FILE *)file_pointer,s);
  yyparse(s);
  yylex_destroy(s);
  fclose(file_pointer);
  return 0;
}

int main(int argc, char *argv[])
{
  int num;
  printf("How many threads you want to create??\n");
  scanf("%d", &num);

  int count = 0;
  FILE *fp[num], *file_pointer;
  char line[256];
    
  file_pointer = fopen("test.txt", "r");
  
  while (fgets(line, sizeof(line), file_pointer))
  {
	  char file_name[32] = "test_";
	  char dummy[4];
	  char dummy2[5] = ".txt";
	  sprintf(dummy, "%d", count);
	  strcat(file_name, dummy);
	  strcat(file_name, dummy2);
    fp[count] = fopen(file_name, "a");
    fprintf(fp[count], "%s", line);
    fclose(fp[count]);
    count++;
    if(count == num)
    {
      count = 0;
    }
  }
  
  struct struct_arg arguments;
  pthread_t tid[num];
    
  int i = 0;
  while(i < num)
  {
	  char file_name[32] = "test_";
	  char dummy[4];
  	char dummy2[5] = ".txt";
  	sprintf(dummy, "%d", i);
  	strcat(file_name, dummy);
  	strcat(file_name, dummy2); 
  	arguments.file = (unsigned char*) file_name;
  	pthread_create(&tid[i], NULL, &parse, (void *) &arguments);
  	sleep(1);
	  i++;
  }

  int n = 0;
  
  while(n < num)
  {
    pthread_join(tid[n], NULL);
	  n++;
  }

  int k = 0;
  while(k < num)
  {
	  char file_name[32] = "test_";
	  char dummy[4];
	  char dummy2[5] = ".txt";
	  sprintf(dummy, "%d", k);
	  strcat(file_name, dummy);
	  strcat(file_name, dummy2); 
	  remove(file_name);
	  k++;
  }

  return 0;
}
