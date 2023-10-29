%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int yylex();
    extern FILE* yyin;
    extern FILE* yyout;

%}

%union{
    char* str;
}

%token  <str>Type <str>Void <str>number <str>fnumber <str>literal <str>cliteral <str>assignment <str>bop <str>uop  <str>comp <str>logic  <str>If <str>Else  <str>ret <str>For <str>While <str>True <str>False <str>print <str>scan <str>sqob <str>sqcb <str>ob <str>cb <str>fob <str>fcb <str>scolon <str>comma <str> slope  <str>area  <str>point  <str>centroid  <str>cc  <str>ic  <str>oc  <str>cr  <str>ir  <str>id 

%%

%%

int main(int argc, char* argv[])
{
    #ifdef YYDEBUG
    yydebug = 1;
    #endif
    yyparse();
    return 0;
}