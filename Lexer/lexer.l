%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    FILE * pt;

%}

blanks [ \t]+
letter [a-zA-Z]
digit [0-9]
number "-"?[1-9]{digit}*
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
\n {yylineno++;}

{blanks} { } 

{type}     {fprintf(pt,"datatype: %s\n",yytext); }
{void}     {fprintf(pt,"datatype: %s\n",yytext); }

{number}   {fprintf(pt,"constant: %s\n",yytext); }
{fnumber}  {fprintf(pt,"constant: %s\n",yytext); 
/* number and floating point numbers are differentiated for potential use in semantic analysis */}
{literal}  {fprintf(pt,"constant: %s\n",yytext); }
{cliteral} {fprintf(pt,"constant: %s\n",yytext); }

{assignment} {fprintf(pt,"operator: %s\n",yytext); }
{bop}      {fprintf(pt,"operator: %s\n",yytext); }
{addition} {fprintf(pt,"operator: %s\n",yytext); }
{uop}      {fprintf(pt,"operator: %s\n",yytext); }
{comparision}  {fprintf(pt,"operator: %s\n",yytext); }
{logic}    {fprintf(pt,"operator: %s\n",yytext); }

{if}       {fprintf(pt,"reserved keyword: %s\n",yytext); }
{else}     {fprintf(pt,"reserved keyword: %s\n",yytext); }
{return}   {fprintf(pt,"reserved keyword: %s\n",yytext); }
{for}      {fprintf(pt,"reserved keyword: %s\n",yytext); }
{while}    {fprintf(pt,"reserved keyword: %s\n",yytext); }
{true}     {fprintf(pt,"reserved keyword: %s\n",yytext); }
{false}    {fprintf(pt,"reserved keyword: %s\n",yytext); }
{print}    {fprintf(pt,"reserved keyword: %s\n",yytext); }
{scan}     {fprintf(pt,"reserved keyword: %s\n",yytext); }
{struct}   {fprintf(pt,"reserved keyword: %s\n",yytext); }
{typedef}  {fprintf(pt,"reserved keyword: %s\n",yytext); }
{break}    {fprintf(pt,"reserved keyword: %s\n",yytext); }
{continue} {fprintf(pt,"reserved keyword: %s\n",yytext); }

{sqob}     {fprintf(pt,"punctuation: %s\n",yytext); }
{sqcb}     {fprintf(pt,"punctuation: %s\n",yytext); }
{ob}       {fprintf(pt,"punctuation: %s\n",yytext); }
{cb}       {fprintf(pt,"punctuation: %s\n",yytext); }
{fob}      {fprintf(pt,"punctuation: %s\n",yytext); }
{fcb}      {fprintf(pt,"punctuation: %s\n",yytext); }


{scolon}   {fprintf(pt,"punctuation: %s\n",yytext); }
{comma}    {fprintf(pt,"punctuation: %s\n",yytext); }
{dot}      {fprintf(pt,"punctuation: %s\n",yytext); }

{slope}    {fprintf(pt,"reserved keyword: %s\n",yytext); }
{area}     {fprintf(pt,"reserved keyword: %s\n",yytext); }
{point}    {fprintf(pt,"reserved keyword: %s\n",yytext); }
{centroid} {fprintf(pt,"reserved keyword: %s\n",yytext); }
{cc}       {fprintf(pt,"reserved keyword: %s\n",yytext); }
{ic}       {fprintf(pt,"reserved keyword: %s\n",yytext); }
{oc}       {fprintf(pt,"reserved keyword: %s\n",yytext); }
{cr}       {fprintf(pt,"reserved keyword: %s\n",yytext); }
{ir}       {fprintf(pt,"reserved keyword: %s\n",yytext); }
{triangle} {fprintf(pt,"reserved keyword: %s\n",yytext); }

{id}       {fprintf(pt,"identifier: %s\n",yytext); }

. {printf("lexical error: token %s is undefined\n",yytext); return 0; }

%%

int yywrap(){return 1;}
int main(int argc, char* argv[]){
    
    yyin = fopen(argv[1],"r");
    pt = fopen("tokens.txt","w");
    yylex();
    fclose(pt);
    
    return 0;
}
