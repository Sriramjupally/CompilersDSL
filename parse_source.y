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
<str>assignment <str>bop <str>add <str>uop  <str>comp <str>logic  <str>If <str>Else  
<str>ret <str>For <str>While <str>True <str>False <str>print <str>scan <str>Struct 
<str>Typedef <str>Break <str>Continue <str>sqob <str>sqcb <str>ob <str>cb <str>fob 
<str>fcb <str>scolon <str>comma <str>dot <str> slope <str>area  <str>point  <str>centroid 
<str>cc  <str>ic  <str>oc  <str>cr  <str>ir  <str>triangle <str>main <str>id 

%%

S : 
  | StructHelp S
  | Method S;
/* Main method is mandatary in our language GeoC. It will be implemented by semantic deadline */

Bop : bop | add

StructHelp : Struct id fob StructBody fcb scolon;

StructBody : Declstmt 
           | Declstmt StructBody;
/* Struct body cannot be empty */

Declstmt : Type IDCID scolon
         | Struct id IDCID scolon;    

IDCID : id comma IDCID 
      | id sqob number sqcb comma IDCID
      | id
      | id sqob number sqcb;

constant : number 
         | fnumber
         | True
         | False
         | literal
         | cliteral;

Method : Type id ob Arguments cb fob MethodBody fcb;

Arguments : Type id 
          | Type id comma Arguments;

MethodBody : 
           | Stmt MethodBody;
/* return statement for a non void function is also mandatory in our language. 
It will be implemented by the semantic deadline  */

Stmt : Declstmt
     | CallStmt scolon 
     | ExprStmt
     | Loop
     | CondStmt
     | UopStmt
     | RetStmt
     | PrintStmt 
     | fob MethodBody fcb
/* Empty scopes are not allowed in our language */

predicatePart : constant
              | id  
              | CallStmt
              | ob predicate cb;
              
predicate : predicatePart
          | predicatePart logic predicate
          | predicatePart Bop predicate
          | predicatePart comp predicate;  

/* calling other functions in predicated is not allowed in GeoC */

CondStmt : If ob predicate cb fob MethodBody fcb ElseHelp;

ElseHelp : 
         | Else fob MethodBody fcb
         | Else CondStmt;

ExprStmt : id assignment predicate scolon
         | id dot id assignment predicate;

CallStmt : id ob CallArguments cb;

CallArguments : id
              | constant
              | id comma CallArguments
              | constant comma CallArguments  

RetStmt : ret constant scolon
        | ret scolon
        | ret id scolon;

PrintStmt : print ob PrintHelp cb scolon;

PrintHelp : id
          | constant
          | id add PrintHelp
          | constant add PrintHelp;

Loop : Fo 
     | Whil;

Fo : For ob ForHelp scolon predicate scolon UopStmt cb fob ForBody fcb;

ForHelp : Declstmt 
        | ExprStmt;

ForBody : 
        | Stmt ForBody
        | Break scolon ForBody
        | Continue scolon ForBody;

Whil : While ob predicate cb fob WhileBody fcb;

WhileBody : 
          | Stmt WhileBody
          | Break scolon WhileBody
          | Continue scolon WhileBody;   

UopStmt : id uop;

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