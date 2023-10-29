%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int yylex();
    int yyerror(char *s);
    int main = 0;
    // used for handling errors such as manin function not found
    extern FILE* yyin;
    extern FILE* yyout;
    
    // when  you run bison -d -t parse_source.y, two files are generated parse_source.tab.c and parse_source.tab.h
    // parse_source.tab.c contains the C code corresponding to our grammar
    // parse_source.tab.h is like the header of parse_source.tab.c, it contains the tokens the parser can accept 
    // It is included in the lex_source.l.(Connecting lexer and Parser)
    //Compile the lexer and parser together and pass the GeoC file as an argument to the /a.out program.

%}

%union{
    char* str;
}

%token  <str>Type <str>Void <str>number <str>fnumber <str>literal <str>cliteral 
<str>assignment <str>bop <str>uop  <str>comp <str>logic  <str>If <str>Else  
<str>ret <str>For <str>While <str>True <str>False <str>print <str>scan <str>Struct 
<str>Typedef <str>Break <str>Continue <str>sqob <str>sqcb <str>ob <str>cb <str>fob 
<str>fcb <str>scolon <str>comma <str> slope <str>area  <str>point  <str>centroid 
<str>cc  <str>ic  <str>oc  <str>cr  <str>ir  <str>triangle <str>id 

%%

S : 
  | StructHelp S
  | Method S;

StructHelp : Struct id fob StructBody fcb scolon;

StructBody : Declstmt scolon
           | Declstmt scolon StructBody;
/* Struct body cannot be empty */

Declstmt : Type IDCID;

IDCID : id comma IDCID 
      | id;





%%

int yyerror(char *s){

}
int main(int argc, char* argv[])
{
    #ifdef YYDEBUG
    yydebug = 1;
    #endif
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    yyparse();
    return 0;
}