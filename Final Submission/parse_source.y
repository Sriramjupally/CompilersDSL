%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <vector>
    #include <iostream>
    #include "stab.hpp"
    #include <fstream>
    

    int yylex();
    void yyerror(const char *s);
    // used for handling errors such as manin function not found
    extern FILE* ps;
    extern FILE* yyin;
    extern FILE* yyout;
    extern int yylineno;
    int parse_scope = 0;

    ofstream fout("output.cpp");
    vector<string> decl_printer;
    vector<string> method_printer;
    vector<string> predicate_printer;
    vector<string> op_printer;
    vector<string> call_printer;
    vector<string> print_printer;
    string exprhelp;
    string callhelp;
    string inbuiltcallhelp;
    int elsehelp = 0;
    // fout.open("output.cpp");

    // int i =  3;
    
    // when  you run bison -d -t parse_source.y, two files are generated parse_source.tab.c and parse_source.tab.h
    // parse_source.tab.c contains the C code corresponding to our grammar
    // parse_source.tab.h is like the header of parse_source.tab.c, it contains the tokens the parser can accept 
    // It is included in the lex_source.l.(Connecting lexer and Parser)
    //Compile the lexer and parser together and pass the GeoC file as an argument to the /a.out program.
    vector <parlist_entry*> paramlist;
    vector < pair <string,int> > symbol_names;
    string func_name;
    vector<arglist_entry*> arglist;
    vector<arglist_entry*> predicate_type;
    string predicate_datatype;
    string const_type;
    vector<string> decl_predicate_type;
    // bool const_is_array;
    // int consi;
    // int consf;
    // int consc;
    // int conss;
    // int consb;
    string const_value;
%}

%union{
    struct variable {
		char* value;
		int type;
	} attribute ;

    char* str;
}

%token  <attribute> Type Void number 
%token  <attribute>fnumber literal cliteral 
%token  <attribute>assignment  bop  add 
%token  <attribute>uop   comp  printseperator logic   If  Else  
%token  <attribute>ret  For  While  True 
%token  <attribute>False  print  scan  Struct 
%token  <attribute>Typedef  Break  Continue 
%token  <attribute>sqob  sqcb  ob  cb  fob 
%token  <attribute>fcb  scolon  comma 
%token  <attribute>dot   slope  distance area   point 
%token  <attribute>centroid cc   ic   oc   cr  
%token  <attribute>ir   triangle   id 

%%

S : Shelp{
        

};
  

Shelp : 
      | StructHelp  Shelp 
      | Method Shelp; 

/* Bop : bop | add Removed since itb*/

StructHelp : Struct id fob StructBody fcb scolon;

StructBody : Declstmt 
           | Declstmt  StructBody;
/* Struct body cannot be empty */

Declstmt : Type IDCID1 scolon{
            // decl_type = $1.value;
            // cout << "hi" << endl;
            bool b;
            // cout <<"aa aa"<< symbol_names.size() << endl;
            for(int i = 0; i < decl_predicate_type.size(); i++){
                if(decl_predicate_type[i] != $1.value){
                    yyerror("Expression LHS and RHS datatypes does not match");
                }
            }
            reverse(symbol_names.begin(), symbol_names.end());
            // for(int i = 0; i < symbol_names.size(); i++){
            //     cout << symbol_names[i].first << endl;
            // }
            for(int i =0; i < symbol_names.size(); i++){
                // cout << symbol_names[i].first  << endl;
                b = symbol_decleration(symbol_names[i].first, $1.value, symbol_names[i].second, parse_scope, func_name);
                if(!b){
                    // string s = "Variable " + symbol_names[i].first + " already exists";
                    yyerror("Variable already declared");
                    break;
                }
                // cout << "cp" << endl;
                
            }
            fout << $1.value << " ";
            // fout << decl_printer << ";" << endl;
            reverse(decl_printer.begin(), decl_printer.end());
            for(int i = 0; i < decl_printer.size() - 1; i++){
                fout << decl_printer[i] << ", ";
            }
            fout <<  decl_printer[decl_printer.size() - 1] << ";" << endl;
            // int i;
            // for( i=0; i < symbol_names.size() - 1;i++ ){
            //     fout << symbol_names[i].first << ", ";
            // }
            // fout << symbol_names[i].first << ";" << endl;
            decl_printer.clear();
            symbol_names.clear();
            decl_predicate_type.clear();
            //  cout << stabs.size() << endl;
            // if(b){
            //     cout << "Hello" << endl;
            // }
            // cout << stabs[0].size() << endl;
            // print_stabs();
            
        }
         | Struct id IDCID scolon
         | point IDCID2 scolon{
                bool b;
                reverse(symbol_names.begin(), symbol_names.end());
                for(int i = 0; i < decl_predicate_type.size(); i++){
                    if(decl_predicate_type[i] != $1.value){
                        yyerror("Expression LHS and RHS datatypes does not match");
                    }
                }
                for(int i =0; i < symbol_names.size(); i++){
                    b = symbol_decleration(symbol_names[i].first, $1.value, symbol_names[i].second, parse_scope, func_name);
                    if(!b){
                        yyerror("Variable already declared");
                        break;
                    }
                    
                }

                reverse(decl_printer.begin(), decl_printer.end());

                fout << $1.value << " ";
                for(int i = 0; i < decl_printer.size() - 1; i++){
                    fout << decl_printer[i] << ", ";
                }
                fout <<  decl_printer[decl_printer.size() - 1] << ";" << endl;

                decl_printer.clear();
                symbol_names.clear();
                decl_predicate_type.clear();
                // print_stabs();

         }
         | triangle IDCID3 scolon{
                bool b;
                reverse(symbol_names.begin(), symbol_names.end());
                for(int i = 0; i < decl_predicate_type.size(); i++){
                    // cout << decl_predicate_type[i] << endl;
                    if(decl_predicate_type[i] != $1.value){
                        yyerror("Expression LHS and RHS datatypes does not match");
                    }
                }
                for(int i =0; i < symbol_names.size(); i++){
                    b = symbol_decleration(symbol_names[i].first, $1.value, symbol_names[i].second, parse_scope, func_name);
                    if(!b){
                        yyerror("Variable already declared");
                        break;
                    }
                    
                }
                symbol_names.clear();
                decl_predicate_type.clear();
                // print_stabs();

};    

IDCID : id comma IDCID 
      | id sqob number sqcb comma IDCID
      | id
      | id sqob number sqcb;
    
IDCID1 : Ihelp comma IDCID1{
            
            
            // cout << "predicate type is " << predicate_datatype << endl;
            // cout << "declaration type is " << decl_type << endl;
            // if(predicate_datatype != decl_type ){
            //     yyerror("Expression LHS and RHS datatypes does not match");
            // }else{
            //     symbol_names.push_back( make_pair($1.value, 0) );
            // }
            // predicate_datatype = "";
        }
       | id comma IDCID1 {
            // cout << $1.value << endl;
            string temp;
            // cout << $1.value << endl;
            // string temp1 = ",";
            temp = $1.value;
            decl_printer.push_back(temp);
            symbol_names.push_back( make_pair($1.value, 0) );
        }
       | id sqob number sqcb comma IDCID1{
            // cout << $1.value << endl;
            string temp = "";
            string temp1 = $1.value;
            temp += temp1 + "[";
            temp1 = $3.value;
            temp += temp1 + "]";
            decl_printer.push_back(temp);

            // decl_printer += $1.value + temp + $3.value ;
            // temp =  "]," ; 
            // decl_printer += temp;
            // decl_printer += ",";
            symbol_names.push_back( make_pair($1.value, 1) );
        }
       | id {
            // cout << $1.value << endl;
            string temp = $1.value;
            decl_printer.push_back(temp);
            // decl_printer += $1.value;
            symbol_names.push_back( make_pair($1.value, 0) );
        }
       | id assignment predicate{

            // cout << $1.value << endl;
            string temp = $1.value;
            temp += " = ";
            for(int i = 0; i < predicate_printer.size()-1; i++){
                temp += predicate_printer[i] + op_printer[i];
            }
            temp += predicate_printer[ predicate_printer.size() - 1];
            decl_printer.push_back(temp);
            predicate_printer.clear();
            op_printer.clear();

            // decl_printer += 
            decl_predicate_type.push_back(predicate_datatype);
            symbol_names.push_back( make_pair($1.value, 0) );
            predicate_type.clear();
            // cout << "predicate type is " << predicate_datatype << endl;
            // cout << "declaration type is " << decl_type << endl;
            // if(predicate_datatype != decl_type ){
            //     yyerror("Expression LHS and RHS datatypes does not match");
            // }else{
            //     symbol_names.push_back( make_pair($1.value, 0) );
            // }
            // predicate_datatype = "";
        }
       | id sqob number sqcb{
            // cout << $1.value << endl;
            // string temp = "[";
            // decl_printer += $1.value + temp + $3.value;
            // temp = "]";
            // decl_printer += temp;
            string temp = "";
            string temp1 = $1.value;
            temp += temp1 + "[";
            temp1 = $3.value;
            temp += temp1 + "]";
            decl_printer.push_back(temp);
            symbol_names.push_back( make_pair($1.value, 1) );
};

Ihelp : id assignment predicate{
        // cout << $1.value << endl;
        string temp = $1.value;
        temp += " = ";
        for(int i = 0; i < predicate_printer.size()-1; i++){
            temp += predicate_printer[i] + op_printer[i];
        }
        temp += predicate_printer[ predicate_printer.size() - 1];
        // temp += ",";
        decl_printer.push_back(temp);
        predicate_printer.clear();
        op_printer.clear();

        decl_predicate_type.push_back(predicate_datatype);
        symbol_names.push_back( make_pair($1.value, 0) );
        predicate_type.clear();
};
    
IDCID2 : id assignment id comma IDCID2{
            string temp = $1.value;
            string temp1 = $3.value;
            temp += " = " + temp1;
            decl_printer.push_back(temp);
            symbol_names.push_back( make_pair($1.value, 0) );
            stab_entry *a = new stab_entry;
            a = is_symbol_declared($3.value, parse_scope, func_name);
            decl_predicate_type.push_back(a->datatype);
         }
       | Ihelp1 cb IDCID2{
            //   symbol_names.push_back( make_pair($1.value, 0) );
       } 
       | id comma IDCID2 {
            string temp = $1.value;
            // temp +=  ",";
            decl_printer.push_back(temp);
            // cout << $1.value << endl;
            symbol_names.push_back( make_pair($1.value, 0) );
       }
       | id sqob number sqcb comma IDCID2{
            symbol_names.push_back( make_pair($1.value, 1) );
       }
       | id {
            string temp = $1.value;
            decl_printer.push_back(temp);
            symbol_names.push_back( make_pair($1.value, 0) );
       }
       | id assignment id{
            string temp = $1.value;
            string temp1 = $3.value;
            temp += " = " + temp1;
            decl_printer.push_back(temp);
                        decl_printer.push_back(temp);

            symbol_names.push_back( make_pair($1.value, 0) );
            stab_entry *a = new stab_entry;
            a = is_symbol_declared($3.value, parse_scope, func_name);
            decl_predicate_type.push_back(a->datatype);
       }
       | Ihelp1 cb{
            // symbol_names.push_back( make_pair($1.value, 0) );
       }
       | id sqob number sqcb{
            symbol_names.push_back( make_pair($1.value, 1) );
};
