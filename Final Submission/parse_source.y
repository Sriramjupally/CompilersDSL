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
Ihelp1 : Ihelp2 comma predicate{
    predicate_type.clear();
};

Ihelp2  : id assignment ob predicate{
    symbol_names.push_back( make_pair($1.value, 0) );
    predicate_type.clear();
};



IDCID3 : id assignment id comma IDCID3{
                symbol_names.push_back( make_pair($1.value, 0) );
                stab_entry *a = new stab_entry;
                a = is_symbol_declared($3.value, parse_scope, func_name);
                decl_predicate_type.push_back(a->datatype);
        }
       | id assignment ob Point comma Point comma Point cb IDCID3{
              symbol_names.push_back( make_pair($1.value, 0) );
       } 
       | id comma IDCID3{
            symbol_names.push_back( make_pair($1.value, 0) );
         } 
       | id sqob number sqcb comma IDCID3{
            symbol_names.push_back( make_pair($1.value, 1) );
         }
       | id{
            symbol_names.push_back( make_pair($1.value, 0) );
         } 
       | id assignment id{
                symbol_names.push_back( make_pair($1.value, 0) );
                stab_entry *a = new stab_entry;
                a = is_symbol_declared($3.value, parse_scope, func_name);
                decl_predicate_type.push_back(a->datatype);
        }
       | id assignment ob Point comma Point comma Point cb{
            symbol_names.push_back( make_pair($1.value, 0) );
       }
       | id sqob number sqcb{
            symbol_names.push_back( make_pair($1.value, 1) );
};

Point : id {
            inbuiltcallhelp = $1.value;
        } 
      | ob predicate comma predicate cb{
        predicate_type.clear();
      };

constant : number {
            const_type = "int";
            const_value = $1.value ;
        }
         | fnumber{
            const_type = "float";
            const_value = $1.value ;
         }
         | True{
            const_type = "bool";
            const_value = $1.value ;
         }
         | False{
            const_type = "bool";
            const_value = $1.value ;
         }
         | literal{
            const_type = "string";
            const_value = $1.value ;
         }
         | cliteral{
            const_type = "char";
            const_value = $1.value ;
         };

Method : MethodHeader MethodBody fcb {
    parse_scope--;
    stabs.clear();
    fout << "}" << endl;
};

MethodHeader :  Type id ob Arguments cb fob {
                            func_name = $2.value;
                            // cout <<  "cp1" << endl;
                            // for(int i =0; i < paramlist.size(); i++){
                            //     cout << i << endl;
                            //     cout << paramlist[i]->pname << endl;
                            //     cout << paramlist[i]->pdatatype << endl;
                            //     cout << paramlist[i]->is_array << endl;
                            
                            // }
                            reverse(paramlist.begin(), paramlist.end());
                            // cout << "cp100" << endl;
                            
                            bool b = insert_ftab($2.value, $1.value, 0, paramlist );
                            if(!b){
                                yyerror("Function already declared");
                                break; 
                            }
                            // print_ftab();
                            // cout << "cp101" << endl;
                            paramlist.clear();
                            // cout << "cp102" << endl;
                            // print_ftab();
                            // cout << "cp103" << endl;
                            parse_scope++;
                            // cout << "cp104" << endl;

                            reverse(method_printer.begin(), method_printer.end());
                            fout << $1.value << " " << $2.value << "(";
                            for(int i = 0; i < method_printer.size(); i++){
                                fout << method_printer[i] << " ";
                            }
                            fout << "){" << endl;

                            method_printer.clear();

                        }   
    | point id ob Arguments cb fob {
                        func_name = $2.value;
                        // cout <<  "cp1" << endl;
                        // for(int i =0; i < paramlist.size(); i++){
                        //     cout << i << endl;
                        //     cout << paramlist[i]->pname << endl;
                        //     cout << paramlist[i]->pdatatype << endl;
                        //     cout << paramlist[i]->is_array << endl;
                        
                        // }
                        reverse(paramlist.begin(), paramlist.end());
                        // cout << "cp100" << endl;
                        
                        bool b = insert_ftab($2.value, $1.value, 0, paramlist );
                        if(!b){
                            yyerror("Function already declared");
                            break; 
                        }
                        // cout << "cp101" << endl;
                        paramlist.clear();
                        // cout << "cp102" << endl;
                        // print_ftab();
                        // cout << "cp103" << endl;
                        parse_scope++;
                        // cout << "cp104" << endl;
                        reverse(method_printer.begin(), method_printer.end());
                        
                        fout << $1.value << " " << $2.value << "(";
                        for(int i = 0; i < method_printer.size(); i++){
                            fout << method_printer[i] << " ";
                        }
                        fout << "){" << endl;

                        method_printer.clear();
};

Arguments :  
          | Type id {  
                string temp = $1.value;
                temp += " ";
                temp += $2.value;
                method_printer.push_back(temp);
                // test();
                // cout << $2.value << endl;
                // cout << "cp2" << endl;
                parlist_entry* a = new parlist_entry;
                // cout << "cp2.1" << endl;
                a->pname = $2.value;
                // cout << "cp2.2" << endl;
                a->pdatatype = $1.value;
                // cout << "cp2.3" << endl;
                a->is_array = 0;
                // cout << "cp2.4" << endl;
                paramlist.push_back(a);  
            }
          | point id {  
                // test();
                // cout << $2.value << endl;
                // cout << "cp2" << endl;
                parlist_entry* a = new parlist_entry;
                // cout << "cp2.1" << endl;
                a->pname = $2.value;
                // cout << "cp2.2" << endl;
                a->pdatatype = $1.value;
                // cout << "cp2.3" << endl;
                a->is_array = 0;
                // cout << "cp2.4" << endl;
                paramlist.push_back(a);  
                string temp = "point";
                temp += " ";
                temp += $2.value;
                method_printer.push_back(temp);
            }
          | Type id comma  Arguments {   
                // cout << "cp" <<  i << endl;
                // i++;
                string temp = $1.value;
                temp += " ";
                temp += $2.value;
                temp += ",";
                method_printer.push_back(temp);

                parlist_entry* a = new parlist_entry;
                a->pname = $2.value;
                a->pdatatype = $1.value;
                a->is_array = 0;
                paramlist.push_back(a);   
            }
          | point id comma  Arguments {   
                // cout << "cp" <<  i << endl;
                // i++;
                string temp = "point";
                temp += " ";
                temp += $2.value;
                temp += ",";
                method_printer.push_back(temp);

                parlist_entry* a = new parlist_entry;
                a->pname = $2.value;
                a->pdatatype = $1.value;
                a->is_array = 0;
                paramlist.push_back(a);   
};

/* ArgumentsHelp : Arguments; */

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
     | Break scolon 
     | Continue scolon
     | stmtHelper MethodBody fcb{
        parse_scope--;
        stabs.pop_back();
     };
/* Empty scopes are not allowed in our language */

stmtHelper : fob {
    parse_scope++;
    vector <stab_entry*> v;
    stabs.push_back(v);
};

predicatePart : constant{
                    arglist_entry* b = new arglist_entry;
                    predicate_datatype = const_type;
                    b->datatype = const_type;
                    b->is_array = 0;
                    predicate_printer.push_back(const_value);
                    // cout << "pushing " << const_value << endl;
                    // if(const_type == "int"){
                    //     cout << "pushing " << consi << endl;
                    // }
                    // if(const_type == "float"){
                    //     cout << "pushing " << consf << endl;
                    // }
                    // if(const_type == "bool"){
                    //     cout << "pushing " << consb << endl;
                    // }
                    // if(const_type == "string"){
                    //     cout << "pushing " << conss << endl;
                    // }
                    // if(const_type == "char"){
                    //     cout << "pushing " << consc << endl;
                    // }
                    predicate_type.push_back(b);
                    // const_type = "";
                }
              | id{
                    string temp = $1.value;
                    predicate_printer.push_back(temp);


                    arglist_entry* b = new arglist_entry;
                    stab_entry* a = new stab_entry;
                    a = is_symbol_declared($1.value, parse_scope, func_name);
                    if(a==NULL){
                        yyerror("variable not declared before use");
                    }else{
                        predicate_datatype = a->datatype;
                        b->datatype = a->datatype;
                        b->is_array = a->is_array;
                        predicate_type.push_back(b);
                    }
              } 
              | id dot id{
                    string temp = $1.value;
                    temp += ".";
                    temp+= $3.value;
                    predicate_printer.push_back(temp);

                    arglist_entry* b = new arglist_entry;
                    stab_entry* a = new stab_entry;
                    a = is_symbol_declared($1.value, parse_scope, func_name);
                    if(a==NULL){
                        yyerror("variable not declared before use");
                    }else{
                        predicate_datatype = a->datatype;
                        b->datatype = "float";
                        b->is_array = a->is_array;
                        predicate_type.push_back(b);
                    }
              } 
              | CallStmt{
                    predicate_printer.push_back(callhelp);
                // Push back to predicate_type is happening at Call Stmt Non terminal rules
              }
              | ob predicate cb;
