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

             
predicate : predicatePart{
                // for(int i = 0; i < predicate_type.size(); i++){
                //         cout << predicate_type[i]->datatype << endl;
                //     }
                // predicate_type.clear();
            }
          | predicatePart logic predicate{
             string temp = " ";
             temp += $2.value;
             temp += " ";
             op_printer.push_back(temp);
            predicate_datatype = "bool";
            // for(int i = 0; i < predicate_type.size(); i++){
            //             cout << predicate_type[i]->datatype << endl;
            //         }
            // predicate_type.clear();
          }
          | predicatePart bop predicate{
                 string temp = " ";
                 temp += $2.value;
                 temp += " ";
                 op_printer.push_back(temp);
                predicate_datatype = predicate_type[0]->datatype;
                // for(int i = 0; i < predicate_type.size(); i++){
                //         cout << predicate_type[i]->datatype << endl;
                //     }
                for(int i = 0; i < predicate_type.size(); i++){
                    string dtype = predicate_type[i]->datatype;
                    if(dtype == "point"){
                        yyerror("Operation is not supported on points");
                    }
                    if(dtype == "triangle"){
                        yyerror("Operation is not supported on triangles");
                    }
                    if(dtype == "string"){
                        yyerror("Operation is not supported on strings");
                    }
                    if(dtype == "char"){
                        yyerror("Operation is not supported on characters");
                    }
                    if(dtype == "bool"){
                        yyerror("Operation is not supported on Boolean elements");
                    }
                }
                string modulo = "%";
                if($2.value == modulo){
                    predicate_datatype = "int";
                }
                else{
                    string dtype;
                    for(int i = 0; i < predicate_type.size(); i++){

                        dtype = predicate_type[i]->datatype;

                        if(predicate_datatype == "int" && dtype == "float"){
                            predicate_datatype = "float";
                        }
                        if(predicate_datatype == "int" && dtype == "double"){
                            predicate_datatype = "double";
                        }

                        if(predicate_datatype == "long" && dtype == "float"){
                            predicate_datatype = "float";
                        }
                        if(predicate_datatype == "long" && dtype == "double"){
                            predicate_datatype = "double";
                        }                        
                    }
                }
                // predicate_type.clear();

           
            }
          | predicatePart add predicate{
                op_printer.push_back(" + ");
                // cout << op_printer.size() << endl;
                string s = "+";
                if($2.value == s){
                    int x = predicate_type[0]->is_array;
                    string y = predicate_type[0]->datatype;
                    predicate_datatype = predicate_type[0]->datatype;
                    // cout << predicate_type.size();
                    // for(int i = 0; i < predicate_type.size(); i++){
                    //     cout << predicate_type[i]->datatype << endl;
                    // }
                    // "int"|"char"|"string"|"bool"|"long"|"float"|"double"
                    string i = "int";
                    string c = "char";
                    string str = "string";
                    string b = "bool";
                    string l = "long";
                    string f = "float";
                    string d = "double";
                    // vector <string> v;
                    string dtype;
                    
                    for(int i =0; i < predicate_type.size(); i++){

                        dtype = predicate_type[i]->datatype;
                        if(dtype == "point"){
                            yyerror("Addition is not supported on points");
                        }
                        if(dtype == "triangle"){
                            yyerror("Addition is not supported on triangles");
                        }
                        

                        if(predicate_type[i]->is_array != x){
                            yyerror("Cannot add an array and a non array element");
                        }

                        if(predicate_datatype == "int" && dtype == "char"){
                            yyerror("Cannot add  an int element and a char element");
                        }
                        if(predicate_datatype == "int" && dtype == "string"){
                            yyerror("Cannot add  an int element and a string element");
                        }
                        if(predicate_datatype == "int" && dtype == "float"){
                            predicate_datatype = "float";
                        }
                        if(predicate_datatype == "int" && dtype == "double"){
                            predicate_datatype = "double";
                        }
                        


                        if(predicate_datatype == "long" && dtype == "char"){
                            yyerror("Cannot add  a long element and a char element");
                        }
                        if(predicate_datatype == "long" && dtype == "string"){
                            yyerror("Cannot add  a long element and a string element");
                        }
                        if(predicate_datatype == "long" && dtype == "float"){
                            predicate_datatype = "float";
                        }
                        if(predicate_datatype == "long" && dtype == "double"){
                            predicate_datatype = "double";
                        }
                        


                        if(predicate_datatype == "float" && dtype == "char"){
                            yyerror("Cannot add  a float element and a char element");
                        }
                        if(predicate_datatype == "float" && dtype == "string"){
                            yyerror("Cannot add  a float element and a string element");
                        }
                        


                        if(predicate_datatype == "double" && dtype == "char"){
                            yyerror("Cannot add  a double element and a char element");
                        }
                        if(predicate_datatype == "double" && dtype == "string"){
                            yyerror("Cannot add  a double element and a string element");
                        }

                        if(predicate_datatype == "bool" && dtype == "char"){
                            yyerror("Cannot add  a bool element and a char element");
                        }
                        if(predicate_datatype == "bool" && dtype == "string"){
                            yyerror("Cannot add  a bool element and a string element");
                        }
                        


                        if(predicate_datatype == "string" && dtype == "int"){
                            yyerror("Cannot add  a string element and an int element");
                        }
                        if(predicate_datatype == "string" && dtype == "float"){
                            yyerror("Cannot add  a string element and a float element");
                        }
                        if(predicate_datatype == "string" && dtype == "bool"){
                            yyerror("Cannot add  a string element and a bool element");
                        }
                        if(predicate_datatype == "string" && dtype == "long"){
                            yyerror("Cannot add  a string element and a long element");
                        }
                        if(predicate_datatype == "string" && dtype == "double"){
                            yyerror("Cannot add  a string element and a double element");
                        }

                        if(predicate_datatype == "char" && dtype == "int"){
                            yyerror("Cannot add  a char element and an int element");
                        }
                        if(predicate_datatype == "char" && dtype == "float"){
                            yyerror("Cannot add  a char element and a float element");
                        }
                        if(predicate_datatype == "char" && dtype == "bool"){
                            yyerror("Cannot add  a char element and a bool element");
                        }
                        if(predicate_datatype == "char" && dtype == "long"){
                            yyerror("Cannot add  a char element and a long element");
                        }
                        if(predicate_datatype == "char" && dtype == "double"){
                            yyerror("Cannot add  a char element and a double element");
                        }
                        if(predicate_datatype == "char" && dtype == "char"){
                            predicate_datatype = "string";
                        }
                        if(predicate_datatype == "char" && dtype == "string"){
                            predicate_datatype = "string";
                        }
                        
                    }

                
                    // predicate_type.clear();
                }
            }
          | predicatePart comp predicate{
                 string temp = " ";
                 temp += $2.value;
                 temp += " ";
                 op_printer.push_back(temp);
                predicate_datatype = "bool";
                // predicate_type.clear();
};  

CondStmt : CondHelp1 ElseHelp;

CondHelp1 : CondHelp MethodBody fcb{
                fout << "}" << endl;
                 parse_scope--;
                stabs.pop_back();   
            };

CondHelp : CondHelp2 cb fob {
                parse_scope++;
                vector <stab_entry*> v;
                stabs.push_back(v);
            };

CondHelp2 : If ob predicate{
                if(elsehelp == 0){
                    fout << "if(";
                }else{
                    fout << "else if(";
                    elsehelp = 0;
                }   
                reverse(op_printer.begin(), op_printer.end());
                // fout << $1.value << "= ";
                
                for(int i = 0; i < predicate_printer.size()-1; i++){
                        fout << predicate_printer[i] << op_printer[i];
                }
                fout << predicate_printer[predicate_printer.size()-1];
                fout << "){" << endl;


                predicate_printer.clear();
                op_printer.clear();

                predicate_type.clear();
};

ElseHelp : 
         | ElseHelp1 MethodBody fcb {
                fout << "}" << endl;
                 parse_scope--;
                stabs.pop_back();   
            }
         | Ehelp1 CondStmt{
            // elsehelp = 1;
            // fout << "else ";
         };

Ehelp1 : Else{
            elsehelp = 1;
            // fout << "else ";
         };

ElseHelp1 : Else  fob{
                fout << "else{" << endl;
                parse_scope++;
                vector <stab_entry*> v;
                stabs.push_back(v); 
            };

ExprStmt : id assignment predicate scolon {

                // cout << $1.value << " assignment is happening" << endl;

                stab_entry* a = new stab_entry;
                a = is_symbol_declared($1.value, parse_scope, func_name);
                if(a== NULL){
                    yyerror("Variable is not declared before use");
                }else{
                    if(a->datatype != predicate_datatype){
                        yyerror("Expression LHS and RHS datatypes does not match");
                    }
                }
                // cout << predicate_printer.size() << "at line no" << yylineno;
                // cout << op_printer.size() << "at line no" << yylineno;

                reverse(op_printer.begin(), op_printer.end());
                fout << $1.value << "= ";
                
                for(int i = 0; i < predicate_printer.size()-1; i++){
                        fout << predicate_printer[i] << op_printer[i];
                }
                fout << predicate_printer[predicate_printer.size()-1];
                fout << ";" << endl;


                predicate_printer.clear();
                op_printer.clear();
                predicate_type.clear();

           }
         | id dot id assignment predicate scolon{

                reverse(op_printer.begin(), op_printer.end());

                fout << $1.value << "." << $3.value << "= ";
                for(int i = 0; i < predicate_printer.size()-1; i++){
                        fout << predicate_printer[i] << op_printer[i];
                }
                fout << predicate_printer[predicate_printer.size()-1];
                fout << ";" << endl;

                predicate_printer.clear();
                op_printer.clear();
                predicate_type.clear();
         }
         | Exprhelp comma predicate cb scolon{
            fout << exprhelp << ".y= ";
            for(int i = 0; i < predicate_printer.size()-1; i++){
                     fout << predicate_printer[i] << op_printer[i];
            }
            fout << predicate_printer[predicate_printer.size()-1];
            fout << ";" << endl;

            predicate_printer.clear();
            op_printer.clear();

            predicate_printer.clear();
            op_printer.clear();
            predicate_type.clear();
         };
         /* | id assignment ob Point comma Point comma Point cb scolon; */

Exprhelp : id assignment ob predicate{
            exprhelp = $1.value;
            fout << $1.value << ".x= ";
            reverse(op_printer.begin(), op_printer.end());

            for(int i = 0; i < predicate_printer.size()-1; i++){
                     fout << predicate_printer[i] << op_printer[i];
            }
            fout << predicate_printer[predicate_printer.size()-1];
            fout << ";" << endl;

            predicate_printer.clear();
            op_printer.clear();

            predicate_type.clear();
         };

CallStmt : id ob CallArguments cb{
             bool b = check_func_exists($1.value);
             if(b){
                // cout << predicate_printer.size() << "at line no" << yylineno;
                // cout << op_printer.size() << "at line no" << yylineno;
                // cout << "Yes at line " << yylineno << endl;
                ftab_entry* a = new ftab_entry;
                // reverse(arglist.begin(), arglist.end());
                // for(int i = 0; i < arglist.size(); i++){
                //     cout << arglist[i]->datatype << endl;
                // }
                
                a = check_func($1.value, arglist );
                //  cout << "cp" << endl;
                if(a == NULL){
                    yyerror("Function parameters and arguments didn't match");
                }
                 
                //  else{
                //     cout << "Hello" << endl;
                //  }

                string temp;
                callhelp = $1.value;
                callhelp += "(";
                // fout << $1.value << "(";
                for(int i = 0; i < call_printer.size() - 1; i++){
                    // fout <<  call_printer[i] << ", ";
                    callhelp += call_printer[i] + ", ";
                }
                if(call_printer.size() > 0){
                    callhelp += call_printer[call_printer.size() - 1];
                }
                callhelp += ")";
                call_printer.clear();



                predicate_datatype = a ->ret_type;
                arglist_entry* c = new arglist_entry;
                c->datatype = a->ret_type;
                c->is_array = a->is_array;
                predicate_type.push_back(c);

                arglist.clear();
             }else{
                yyerror("Function not declared before use");
             }



         }
         |  slopeHelp Point cb{
                callhelp += inbuiltcallhelp + ")";
         }
         | distanceHelp Point cb{
                callhelp += inbuiltcallhelp + ")";
         }
         | area ob id comma id comma id cb{
            callhelp = $1.value;
            callhelp += "(";
            callhelp = $3.value;
            callhelp += ",";
            callhelp = $5.value;
            callhelp += ",";
            callhelp = $7.value;
            callhelp += ")";
         }
         | centroid ob id comma id comma id cb{
            callhelp = $1.value;
            callhelp += "(";
            callhelp = $3.value;
            callhelp += ",";
            callhelp = $5.value;
            callhelp += ",";
            callhelp = $7.value;
            callhelp += ")";
         }
         | cc ob id comma id comma id cb{
            callhelp = $1.value;
            callhelp += "(";
            callhelp = $3.value;
            callhelp += ",";
            callhelp = $5.value;
            callhelp += ",";
            callhelp = $7.value;
            callhelp += ")";
         }    
         | cr ob id comma id comma id cb{
            callhelp = $1.value;
            callhelp += "(";
            callhelp = $3.value;
            callhelp += ",";
            callhelp = $5.value;
            callhelp += ",";
            callhelp = $7.value;
            callhelp += ")";
         }
         | ir ob id comma id comma id cb{
            callhelp = $1.value;
            callhelp += "(";
            callhelp = $3.value;
            callhelp += ",";
            callhelp = $5.value;
            callhelp += ",";
            callhelp = $7.value;
            callhelp += ")";
         }
         | ic ob id comma id comma id cb{
            callhelp = $1.value;
            callhelp += "(";
            callhelp = $3.value;
            callhelp += ",";
            callhelp = $5.value;
            callhelp += ",";
            callhelp = $7.value;
            callhelp += ")";
         }
         | oc ob id comma id comma id  cb{
            callhelp = $1.value;
            callhelp += "(";
            callhelp = $3.value;
            callhelp += ",";
            callhelp = $5.value;
            callhelp += ",";
            callhelp = $7.value;
            callhelp += ")";
         };

slopeHelp : slope ob Point comma{
                callhelp = $1.value;
                callhelp += "(";
                callhelp += inbuiltcallhelp + ",";
            };
distanceHelp : distance ob Point comma{
                callhelp = $1.value;
                callhelp += "(";
                callhelp += inbuiltcallhelp + ",";
            };
            


/* Points : Point comma Points
       | Point  */

CallArguments : 
              | id  {
                    string temp = $1.value;
                    call_printer.push_back(temp);
                    // cout << "cp1" << endl;
                    arglist_entry* a = new arglist_entry;
                    // cout << "cp2" << endl;
                    stab_entry* c = new stab_entry;
                    c = is_symbol_declared($1.value, parse_scope, func_name );
                    // cout << "cp3" << endl;
                    if(c!= NULL){
                        a->datatype = c->datatype;
                        // cout << "cp4" << endl;
                        a->is_array = c->is_array;
                        // cout << "cp5" << endl;
                        arglist.push_back(a);
                        // cout << "cp6" << endl;
                    }else{
                        yyerror("variable not declared before use");
                    }

              }
              | constant{
                    call_printer.push_back(const_value);
                    arglist_entry* a = new arglist_entry;
                    a->is_array = 0;
                    a->datatype = const_type;
                    arglist.push_back(a);
              }
              | CallHelp1 comma CallArguments
              | CallHelp comma CallArguments;

CallHelp : constant{
                     call_printer.push_back(const_value);
                    arglist_entry* a = new arglist_entry;
                    a->is_array = 0;
                    a->datatype = const_type;
                    arglist.push_back(a);
              }  ;

CallHelp1 : id{       
                    string temp = $1.value;
                     call_printer.push_back(temp);        
                    arglist_entry* a = new arglist_entry;
                    stab_entry* c = new stab_entry;
                    c = is_symbol_declared($1.value, parse_scope, func_name );
                    if(c!= NULL){
                        a->datatype = c->datatype;
                        a->is_array = c->is_array;
                        arglist.push_back(a);
                    }else{
                        yyerror("variable not declared before use");
                    }
              };

RetStmt : ret constant scolon{
                fout << "return " << const_value << ";" << endl;
                ftab_entry* a = new ftab_entry;
                a = check_func_exists1(func_name);
                if(a->ret_type != const_type){
                    yyerror("The datatype of constant and return type of funcion does not match");
                }
                const_type = "";

          }
        | ret scolon{
            fout << "return ;" << endl;
        }
        | ret id scolon{
            fout << "return " << $2.value << ";" << endl;
            stab_entry* a = new stab_entry;
            a = is_symbol_declared($2.value, parse_scope, func_name);
            if(a == NULL){
                yyerror("variable not declared before use");
            }else{
                ftab_entry* b = new ftab_entry;
                b = check_func_exists1(func_name);
                if(b->ret_type != a->datatype){
                    yyerror("The datatype of variable and return type of funcion does not match");
                }
            }
        };

PrintStmt : print printseperator PrintHelp scolon{
                fout << "cout << ";
                reverse(print_printer.begin(), print_printer.end());
                for(int i = 0; i < print_printer.size() - 1; i++){
                    fout << print_printer[i] << " << ";
                }
                fout <<  print_printer[print_printer.size() - 1] << " << endl;" << endl;
                print_printer.clear();
            };

PrintHelp : id{
                string temp = $1.value;
                print_printer.push_back(temp);
            }
          | constant{
                print_printer.push_back(const_value);
          }
          | id printseperator PrintHelp{
                string temp = $1.value;
                print_printer.push_back(temp);
          }
          | constant printseperator PrintHelp{
            print_printer.push_back(const_value);
          };

Loop : Fo 
     | Whil;

Fo : ForHelp1 ForBody fcb{
            parse_scope--;
            stabs.pop_back(); 
} ;
ForHelp1 : For ob ForHelp  predicate scolon id uop cb fob{
            predicate_type.clear();
            parse_scope++;
            vector <stab_entry*> v;
            stabs.push_back(v); 
           };
ForHelp : Declstmt 
        | ExprStmt;

ForBody : 
        | Stmt ForBody;

Whil : WhileHelp WhileBody fcb{
            parse_scope--;
            stabs.pop_back(); 
}  ;

WhileHelp : While ob predicate cb fob {
            parse_scope++;
            vector <stab_entry*> v;
            stabs.push_back(v); 
           };
WhileBody : 
          | Stmt WhileBody;
             

UopStmt : id uop scolon{
            // cout << "In lineno " << yylineno << endl;
            fout << $1.value << $2.value << ";" << endl;
            stab_entry* a = new stab_entry;
            a = is_symbol_declared($1.value, parse_scope, func_name);
            if(a==NULL){
                yyerror("Variable is not declared before use");
            }
         }
        |  id dot id uop scolon{
            stab_entry* a = new stab_entry;
            a = is_symbol_declared($1.value, parse_scope, func_name);
            if(a==NULL){
                yyerror("Variable is not declared before use");
            }
         };

%%

void yyerror(const char* s){
	printf("%s at line number %d\n",s,yylineno);
    fout << s << "at line number " << yylineno;
    exit(0);
}

int main(int argc, char* argv[])
{
    /* #ifdef YYDEBUG */
    /* yydebug = 1; */
    /* #endif */
    FILE *fp = fopen(argv[1],"r");
    yyin = fp;
   
    /* fout << "hi" << endl;
     */
    /* ps = fopen("output.txt", "w"); */
    /* fprintf(ps,"Hi\n"); */

    

    fout << "#include <iostream>" << endl;
    fout << "#include <cmath>" << endl;
    fout << "using namespace std;" << endl;
    fout << "struct point{" << endl << "float x;" << endl << "float y;" << endl << "};" << endl;  
    fout << "typedef struct point point;" << endl;

    fout << "float slope(point p1, point p2){"  << endl;
    fout << "   float f;" << endl;
    fout << "   if(p1.x == p2.x && p1.y == p2.y){" << endl;
    fout << "       return -1;" << endl;
    fout << "   }else{" << endl;
    fout << "       f = (p2.y - p1.y)/(p2.x - p1.x);" << endl;
    fout << "   }" << endl;
    fout << "   return f;" << endl;
    fout << "}" << endl;

    fout << "float distance(point p1, point p2){"  << endl;
    fout << "   float f;" << endl;
    fout << "   if(p1.x == p2.x && p1.y == p2.y){" << endl;
    fout << "       return 0;" << endl;
    fout << "   }else{" << endl;
    fout << "       f = (p2.y - p1.y)*(p2.y - p1.y) + (p2.x - p1.x)*(p2.x - p1.x);" << endl;
    fout << "       f = sqrt(f);" << endl;
    fout << "   }" << endl;
    fout << "   return f;" << endl;
    fout << "}" << endl;

    fout << "point centroid(point a, point b, point c){"  << endl;
    fout << "   point p;"  << endl;
    fout << "   p.x = (a.x + b.x + c.x)/3;"  << endl;
    fout << "   p.y = (a.y + b.y + c.y)/3;"  << endl;
    fout << "   return p;"  << endl;
    fout << "}" << endl;

    fout << "float area(point a, point b, point c){"  << endl;
    fout << "   if(slope(a,b) == slope(b,c)){"  << endl;
    fout << "      return 0;"  << endl;
    fout << "   }else{"  << endl;
    fout << "      float f;"  << endl;
    fout << "      f = 0.5*abs(a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y));"  << endl;
    fout << "     return f;"  << endl;
    fout << "   }"  << endl;
    fout << "}"  << endl;

    fout << "float cr(point a, point b, point c){"  << endl;
    fout << "   float f1 = distance(a,b);"  << endl;
    fout << "   float f2 = distance(b,c);"  << endl;
    fout << "   float f3 = distance(c,a);"  << endl;
    fout << "   float f4 = area(a,b,c);"  << endl;
    fout << "   float f = f1*f2*f3/f4;"  << endl;
    fout << "   return f;"  << endl;
    fout << "}"  << endl;   



    yyparse();
    printf("The code is semantically and syntactically correct\n");
    fout.close();
    /* fclose(ps); */
    return 0;
}
