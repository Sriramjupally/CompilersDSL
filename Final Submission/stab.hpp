#include <iostream>
#include <stdio.h>
#include <vector>


using namespace std;

//  ofstream fout;
// fout.open("output.cpp");

int insert_inbuilt_functions = 0;


struct stab_entry{
    string id_name;
    string datatype;
    int is_array;
    int scope;
};
typedef struct stab_entry stab_entry;
// vector <stab_entry*> stab;
vector <vector <stab_entry*> > stabs; 

struct parlist_entry{
    string pname;
    string pdatatype;
    int is_array;
};
typedef struct parlist_entry parlist_entry;


struct ftab_entry{
    string f_name;
    string ret_type;
    int is_array;
    vector <parlist_entry*> plist;
};
typedef struct ftab_entry ftab_entry;
vector <ftab_entry*> ftab;

void print_ftab(){
    printf("\n\n");
    printf("NAME   RETURNTYPE   IS_ARRAY  PAR_LIST \n");
    printf("______________________________________________________________\n\n");
    for(int i = 0; i < ftab.size(); i++){
        cout << ftab[i]->f_name << "  " << ftab[i]->ret_type << "  " << ftab[i]->is_array << " ";
        cout << "[ ";
        for(int j = 0; j < ftab[i]->plist.size(); j++){
            cout << ftab[i]->plist[j]->pname << " " << ftab[i]->plist[j]->pdatatype << " " <<
            ftab[i]->plist[j]->is_array << ";  ";
        }
        cout << " ]" << endl;
    
    }
}


void print_stabs(){
    for(int i = 0; i < stabs.size(); i++){
        printf("\n\n");
        printf("\nNAME   DATATYPE   TYPE   SCOPE \n");
        printf("_______________________________________\n\n");
        vector <stab_entry*> v = stabs[i];
        for(int j =0; j < stabs[i].size(); j++){
            cout << v[j]->id_name << " " << v[j]->datatype << " " << v[j]->is_array << " " << v[j]->scope << " " << endl;
        }
    }
}

bool check_func_exists(string name){
    int i = 0;
    while( i < ftab.size()){
        if(name == ftab[i]->f_name){
           break;
        }
        i++;
    }
    if(i == ftab.size()){
        return false;
    }else{
        return true;
    }
}

ftab_entry* check_func_exists1(string name){
    int i = 0;
    while( i < ftab.size()){
        if(name == ftab[i]->f_name){
           break;
        }
        i++;
    }
    if(i == ftab.size()){
        return NULL;
    }else{
        return ftab[i];
    }
}

bool insert_ftab(string name, string rtype, int type, vector<parlist_entry*> parlist ){
    if(insert_inbuilt_functions == 0){
        bool b;
        string s = "slope";
        string ret_type = "float";
        int type = 0;
        vector<parlist_entry*> v;
        parlist_entry* a = new parlist_entry;
        a->pname = "a";
        a->pdatatype = "point";
        a->is_array = 0;
        parlist_entry* b1 = new parlist_entry;
        b1->pname = "b";
        b1->pdatatype = "point";
        b1->is_array = 0;
        parlist_entry* c = new parlist_entry;
        c->pname = "c";
        c->pdatatype = "point";
        c->is_array = 0;



        v.push_back(a);
        // a->pname = "b";
        v.push_back(b1);

        ftab_entry* a1 = new ftab_entry;
        a1->f_name = s;
        a1->ret_type = ret_type;
        a1->is_array = type;
        a1->plist = v;
        ftab.push_back(a1);

        s = "distance";
        ftab_entry* a111 = new ftab_entry;
        a111->f_name = s;
        a111->ret_type = ret_type;
        a111->is_array = type;
        a111->plist = v;
        ftab.push_back(a111);
        
        // b = insert_ftab(s, ret_type, type, v);
        // if(b){
        //     cout << "Hello" << endl;
        // }else{
        //     cout << "Bye" << endl;
        // }
        // a->pname = "c";
        v.push_back(c);
        s = "area";
        // b = insert_ftab(s, ret_type, type, v);
        ftab_entry* a2 = new ftab_entry;
        a2->f_name = s;
        a2->ret_type = ret_type;
        a2->is_array = type;
        a2->plist = v;
        ftab.push_back(a2);


        ret_type = "point";
        s = "centroid";
        // b = insert_ftab(s, ret_type, type, v);
        ftab_entry* a3 = new ftab_entry;
        a3->f_name = s;
        a3->ret_type = ret_type;
        a3->is_array = type;
        a3->plist = v;
        ftab.push_back(a3);
        s = "cc";
        // b = insert_ftab(s, ret_type, type, v);
        ftab_entry* a4 = new ftab_entry;
        a4->f_name = s;
        a4->ret_type = ret_type;
        a4->is_array = type;
        a4->plist = v;
        ftab.push_back(a4);
        s = "ic";
        ftab_entry* a5 = new ftab_entry;
        a5->f_name = s;
        a5->ret_type = ret_type;
        a5->is_array = type;
        a5->plist = v;
        ftab.push_back(a5);
        // b = insert_ftab(s, ret_type, type, v);
        s = "oc";
        // b = insert_ftab(s, ret_type, type, v);
        ftab_entry* a6 = new ftab_entry;
        a6->f_name = s;
        a6->ret_type = ret_type;
        a6->is_array = type;
        a6->plist = v;
        ftab.push_back(a6);
        s = "cr";
        ret_type = "float";
        ftab_entry* a7 = new ftab_entry;
        a7->f_name = s;
        a7->ret_type = ret_type;
        a7->is_array = type;
        a7->plist = v;
        ftab.push_back(a7);
        // b = insert_ftab(s, ret_type, type, v);
        s = "ir";
        // b = insert_ftab(s, ret_type, type, v);
        ftab_entry* a8 = new ftab_entry;
        a8->f_name = s;
        a8->ret_type = ret_type;
        a8->is_array = type;
        a8->plist = v;
        ftab.push_back(a8);
        // print_ftab();
    }
    insert_inbuilt_functions++;
    if(!check_func_exists(name)){
        // cout << "cpendhuku ra ee badha" << endl;
        ftab_entry* a = new ftab_entry;
        a->f_name = name;
        a->ret_type = rtype;
        a->is_array = type;
        a->plist = parlist;
        ftab.push_back(a);
        vector <stab_entry*> v;
        stabs.push_back(v);
        return true;
    }else{
        return false;
    }
}


struct arglist_entry {
    string datatype;
    int is_array;
};
typedef struct arglist_entry arglist_entry;



ftab_entry* check_func(string name, vector<arglist_entry*> v ){
    int i = 0;
    // cout << "cp" << endl;
    // cout << "No of funcs is " << ftab.size() << endl;
    while( i < ftab.size()){
        if(name == ftab[i]->f_name){
           break;
        }
        i++;
    }
    if(i == ftab.size()){
        return NULL;
    }else{
        // cout << "The index of func is " << i << endl;
        int j = 0;
        int len = ftab[i]->plist.size();
        while(j < len){
            if( (v[j]->datatype != ftab[i]->plist[j]->pdatatype)  || (v[j]->is_array != ftab[i]->plist[j]->is_array) ){
                break;
            }
            j++;
        }
        if(j==len){
            return ftab[i];
        }
        else{
            return NULL;
        }
    }
    
}

bool symbol_decleration(string name, string dtype, int type, int s, string fname){
    vector <stab_entry*> v = stabs[s-1];
    int i = 0;
    while( i < v.size()){
         if(name == v[i]->id_name){
            break;
        }
        i++;
    }

    if(i != v.size()){
        return false;
    }

    i = 0;
    while( i < ftab.size()){
        if(fname == ftab[i]->f_name){
           break;
        }
        i++;
    }
    // cout << "The func index is " << i << endl;

    int j = 0;
    int len = ftab[i]->plist.size();

    while(j < len){
        if(name == ftab[i]->plist[j]->pname){
            break;
        }
        j++;
    }

    if(j==len){
        stab_entry* a = new stab_entry ; 
        a->id_name = name;
        a->datatype = dtype;
        a->is_array = type;
        a->scope = s;
        stabs[s-1].push_back(a);
        return true;
    }else{
        return false;
    }
}

stab_entry* is_symbol_declared(string name, int s, string fname){
    if(s==1){
        vector <stab_entry*> v = stabs[0];
        for(int j = 0; j < v.size();  j++){
            if(v[j]->id_name == name){
                return v[j];
            }
        }
    }
    
    for(int i = 1; i <= s; i++){
        // cout << s - i << endl;
        vector <stab_entry*> v = stabs[s-i];
        // cout << v.size();
        for(int j = 0; j < v.size();  j++){
            // cout << v[j]->id_name << endl;
            // cout << "Hello" << endl;
            if(v[j]->id_name == name){
                return v[j];
            }
        }
    }
    int i  = 0;
    while(i < ftab.size()){
        if(ftab[i]->f_name == fname){
            break;
        }
        i++;
    }
    vector <parlist_entry*> v;
    v = ftab[i]->plist; 
    for(i = 0; i < v.size(); i++){
        if(name == v[i]->pname){
            stab_entry* a = new stab_entry;
            a->datatype = v[i]->pdatatype;
            a->is_array = v[i]->is_array;
            a->id_name = v[i]->pname;
            a->scope = 0;
            return a;
        }
    }
    return NULL;
}



// void test(){
//     cout << "Hello" << endl;
// }
