%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int yylex();
    int yyerror(char *s);
    // used for handling errors such as manin function not found
    extern FILE* ps;
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
<str>cc  <str>ic  <str>oc  <str>cr  <str>ir  <str>triangle  <str>id 

%%

S : 
  | {fprintf(ps,"struct");} StructHelp {fprintf(ps,"end of struct");} S 
  | {fprintf(ps,"Method");} Method {fprintf(ps,"end of Method");} S ; 
/* Main method is mandatary in our language GeoC. It will be implemented by semantic deadline */

Bop : bop | add

StructHelp : Struct id fob StructBody fcb scolon;

StructBody : Declstmt {fprintf(ps,"Decleration stmt"); }
           | Declstmt {fprintf(ps,"Decleration stmt"); } StructBody;
/* Struct body cannot be empty */

Declstmt : Type IDCID1 scolon
         | Struct id IDCID scolon
         | point IDCID2 scolon
         | triangle IDCID3 scolon;    

IDCID : id comma IDCID 
      | id sqob number sqcb comma IDCID
      | id
      | id sqob number sqcb;
    
IDCID1 : id assignment predicate comma IDCID1
       | id comma IDCID1 
       | id sqob number sqcb comma IDCID1
       | id 
       | id assignment predicate
       | id sqob number sqcb;
    
IDCID2 : id assignment id comma IDCID2
       | id assignment ob predicate comma predicate cb IDCID2 
       | id comma IDCID2 
       | id sqob number sqcb comma IDCID2
       | id 
       | id assignment id
       | id assignment ob predicate comma predicate cb
       | id sqob number sqcb;

IDCID3 : id assignment id comma IDCID3
       | id assignment ob Point comma Point comma Point cb IDCID3 
       | id comma IDCID3 
       | id sqob number sqcb comma IDCID3
       | id 
       | id assignment id
       | id assignment ob Point comma Point comma Point cb
       | id sqob number sqcb;

Point : id  
      | ob predicate comma predicate cb;

constant : number 
         | fnumber
         | True
         | False
         | literal
         | cliteral;

Method : Type id ob Arguments cb fob MethodBody fcb;

Arguments : 
          | Type id 
          | Type id comma Arguments;

MethodBody : 
           | Stmt MethodBody;
/* return statement for a non void function is also mandatory in our language. 
It will be implemented by the semantic deadline  */

Stmt : Declstmt {fprintf(ps,"Decleration stmt"); }
     | CallStmt scolon {fprintf(ps,"Call stmt"); }
     | ExprStmt {fprintf(ps, "Expression stmt"); }
     | Loop 
     | CondStmt 
     | UopStmt {fprintf(ps, "Unary operation"); }
     | RetStmt {fprintf(ps, "Return stmt"); }
     | PrintStmt {fprintf(ps, "Print stmt"); }
     | Break scolon {fprintf(ps,"Break stmt"); } 
     | Continue scolon {fprintf(ps,"Continue stmt"); } ;
     | fob MethodBody fcb;
/* Empty scopes are not allowed in our language */

predicatePart : constant
              | id  
              | CallStmt
              | ob predicate cb;
              
predicate : predicatePart
          | predicatePart logic predicate
          | predicatePart Bop predicate
          | predicatePart comp predicate;  

CondStmt : If ob predicate cb {fprintf(ps,"If stmt"); }fob MethodBody fcb {fprintf(ps,"end of If stmt"); }ElseHelp;

ElseHelp : 
         | Else  {fprintf(ps,"Else stmt"); }fob MethodBody fcb {fprintf(ps,"end of Else stmt"); }
         | Else {fprintf(ps,"Else"); }CondStmt;

ExprStmt : id assignment predicate scolon
         | id dot id assignment predicate scolon
         | id assignment ob predicate comma predicate cb scolon;

CallStmt : id ob CallArguments cb
         | slope ob Point comma Point cb
         | area ob Points cb
         | centroid ob Points cb
         | cc ob Points cb    
         | cr ob Points cb
         | ir ob Points cb
         | ic ob Points cb
         | oc ob Point comma Point comma Point  cb;

Points : Point comma Points
       | Point 

CallArguments : 
              | id
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

Fo : For ob ForHelp  predicate scolon id uop cb { fprintf(ps,"For loop"); } fob ForBody fcb { fprintf(ps,"end of For loop"); } ;

ForHelp : Declstmt 
        | ExprStmt;

ForBody : 
        | Stmt ForBody;

Whil : While ob predicate cb  { fprintf(ps,"While loop"); } fob WhileBody fcb { fprintf(ps,"end of While loop"); } ;

WhileBody : 
          | Stmt WhileBody;
             

UopStmt : id uop scolon;

%%

int yyerror(char *s){
    fprintf(ps,"invalid statement");
    return 0;
}

int main(int argc, char* argv[])
{
    #ifdef YYDEBUG
    yydebug = 1;
    #endif
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
    ps = fopen("output.txt", "w");
    /* fprintf(ps,"Hi\n"); */
    yyparse();
    fclose(ps);
    return 0;
}