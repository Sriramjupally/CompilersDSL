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
