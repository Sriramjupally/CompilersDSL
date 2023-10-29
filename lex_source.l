%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "parse_source.tab.h"
   int state = 0;
//    we might need state to resolve some issues that come with scope 

%}


letter [a-zA-Z]
digit [0-9]
number [-]?[1-9]?{digit}+
fnumber {number}("."){digit}+
bop ("+"|"-"|"*"|"/"|"%")
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
point ("Point")
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

%%
^[ ]*\n {yylineno++;}
/* This line is there to increase the count even in case of empty lines. useful while showing errors */



{type}     {return Type; }
{void}     {return Void; }

{number}   {return number; }
{fnumber}  {return fnumber; }
/* number and floating point numbers are differentiated for potential use in semantic analysis */
{literal}  {return literal;}
{cliteral} {return cliteral;}

{assignment} {return assignment; }
{bop}      {return bop; }
{uop}      {return uop; }
{comparision}  {return comp; }
{logic}    {return logic; }

{if}       {return If; }
{else}     {return Else; }
{return}   {return ret; }
{for}      {return For; }
{while}    {return While; }
{true}     {return True; }
{false}    {return False; }
{print}    {return print;}
{scan}     {return scan;}
{struct}   {return Struct;}
{typedef}  {return Typedef;}
{break}    {return Break;}
{continue} {return Continue;}

{sqob}     {return sqob; }
{sqcb}     {return sqcb; }
{ob}       {return ob; }
{cb}       {return cb; }
{fob}      {return fob; }
{fcb}      {return fcb; }


{scolon}   {return scolon; }
{comma}    {return comma; }

{slope}    {return slope;}
{area}     {return area;}
{point}    {return point;}
{centroid} {return centroid;}
{cc}       {return cc;}
{ic}       {return ic;}
{oc}       {return oc;}
{cr}       {return cr;}
{ir}       {return ir;}
{triangle} {return triangle;}

{id}       {return id; }

. {printf("lexical error: token %s is undefined\n",yytext); }

%%

int yywrap(){return 1;}