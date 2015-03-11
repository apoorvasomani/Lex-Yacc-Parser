%{
#include <stdio.h>
#include "y.tab.h"
extern int scanner;
%}
%option reentrant bison-bridge
%option noyywrap
%option noinput
%option nounput
NUMBER      [0-9]+
%%

" "         ;
{NUMBER}    {
                yylval->i = atoi(yytext);
                return(NUMBER);
            }
[^0-9\b]    {
                return(yytext[0]);
            }

