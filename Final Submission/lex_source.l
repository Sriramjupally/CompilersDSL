%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "y.tab.h"
    FILE * ps;
   int state = 0;
//    we might need state to resolve some issues that come with scope 

%}

blanks [ \t]+
letter [a-zA-Z]
digit [0-9]
number [-]?[1-9]?{digit}+
fnumber {number}("."){digit}+
bop ("-"|"*"|"/"|"%")
addition("+")
uop ("++"|"--") 
type ("int"|"char"|"string"|"bool"|"long"|"float"|"double")
void ("void")
if ("if")
else ("else")
print ("print")
scan ("scan")
comparision (">="|">"|"<="|"<"|"=="|"!=")
printseperator (<<)
logic ("&&"|"||"|"&"|"|")
return ("return")
id {letter}({letter}|{digit}|"_")*
literal ["][^\"]*["]
cliteral ['][^\']*[']
sqob ("[")
sqcb ("]")
ob ("(")
cb (")")
fob ("{")
fcb ("}") 
scolon (";")
comma (",")
assignment ("=")
while ("while")
for ("for")
true ("true")
false ("false")
slope ("Slope")
area ("Area")
cc ("Circumcenter")
distance ("distance")
point ("point")
ic ("Incenter")
centroid ("Centroid")
oc ("Orthocenter")
cr ("Circumradius")
ir ("Inradius")
triangle ("triangle")
struct ("struct")
typedef ("typedef")
break ("break")
continue ("continue")
dot (".")
%%
\n {yylineno++;
        
/* This line is there to increase the count even in case of empty lines. useful while showing errors */}

{blanks} { } 

{type}     {
        yylval.attribute.value = strdup(yytext);
        return Type;
}
{void}     {
        yylval.attribute.value = strdup(yytext);
        return Void; 
        }

{number}   {
        yylval.attribute.value = strdup(yytext);
        return number; 
        }
{fnumber}  {
         yylval.attribute.value = strdup(yytext);
        return fnumber; 
/* number and floating point numbers are differentiated for potential use in semantic analysis */}
{literal}  {
          yylval.attribute.value = strdup(yytext);
        return literal;}

{cliteral} {
          yylval.attribute.value = strdup(yytext);
        return cliteral;
        }

{assignment} {
         yylval.attribute.value = strdup(yytext);
        return assignment; 
        }
{bop}      {
         yylval.attribute.value = strdup(yytext);
        return bop; 
        }
{addition} {
         yylval.attribute.value = strdup(yytext);
        return add;
        }
{uop}      {
         yylval.attribute.value = strdup(yytext);
        return uop; 
        }
{comparision}  {
         yylval.attribute.value = strdup(yytext);
        return comp; 
        }

{printseperator}  {
         yylval.attribute.value = strdup(yytext);
        return printseperator; 
        }
{logic}    {
         yylval.attribute.value = strdup(yytext);
        return logic; 
        }

{if}       {
         yylval.attribute.value = strdup(yytext);
        return If; 
        }
{else}     {
         yylval.attribute.value = strdup(yytext);
        return Else; 
        }
{return}   {
         yylval.attribute.value = strdup(yytext);
        return ret; 
        }
{for}      {
         yylval.attribute.value = strdup(yytext);
        return For; 
        }
{while}    {
         yylval.attribute.value = strdup(yytext);
        return While; 
        }
{true}     {
         yylval.attribute.value = strdup(yytext);
        return True; 
        }
{false}    {
         yylval.attribute.value = strdup(yytext);
        return False; 
        }
{print}    {
         yylval.attribute.value = strdup(yytext);
        return print;
        }
{scan}     {
         yylval.attribute.value = strdup(yytext);
        return scan;
        }
{struct}   {
         yylval.attribute.value = strdup(yytext);
        return Struct;
        }
{typedef}  {
         yylval.attribute.value = strdup(yytext);
        return Typedef;
        }
{break}    {
         yylval.attribute.value = strdup(yytext);
        return Break;
        }
{continue} {
         yylval.attribute.value = strdup(yytext);
        return Continue;
        }

{sqob}     {
         yylval.attribute.value = strdup(yytext);
        return sqob; 
        }
{sqcb}     {
         yylval.attribute.value = strdup(yytext);
        return sqcb; 
        }
{ob}       {
         yylval.attribute.value = strdup(yytext);
        return ob; 
        }
{cb}       {
         yylval.attribute.value = strdup(yytext);
        return cb; 
        }
{fob}      {
         yylval.attribute.value = strdup(yytext);
        return fob; 
        }
{fcb}      {
         yylval.attribute.value = strdup(yytext);
        return fcb; 
        }


{scolon}   {
         yylval.attribute.value = strdup(yytext);
        return scolon; 
        }
{comma}    {
         yylval.attribute.value = strdup(yytext);
        return comma; 
        }
{dot}      {
         yylval.attribute.value = strdup(yytext);
        return dot; 
        } 

{slope}    {
         yylval.attribute.value = strdup(yytext);
        return slope;
        }
{distance}    {
         yylval.attribute.value = strdup(yytext);
        return distance;
        }
{area}     {
         yylval.attribute.value = strdup(yytext);
        return area;
        }
{point}    {
         yylval.attribute.value = strdup(yytext);
        return point;
        }
{centroid} {
         yylval.attribute.value = strdup(yytext);
        return centroid;
        }
{cc}       {
         yylval.attribute.value = strdup(yytext);
        return cc;
        }
{ic}       {
         yylval.attribute.value = strdup(yytext);
        return ic;
        }
{oc}       {
         yylval.attribute.value = strdup(yytext);
        return oc;
        }
{cr}       {
         yylval.attribute.value = strdup(yytext);
        return cr;
        }
{ir}       {
         yylval.attribute.value = strdup(yytext);
        return ir;
        }
{triangle} {
         yylval.attribute.value = strdup(yytext);
        return triangle;
        }

{id}       {
         yylval.attribute.value = strdup(yytext);
        return id; 
        }

. {printf("lexical error: token %s is undefined\n",yytext); }

%%

int yywrap(){return 1;}
