%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <cstdlib>
#include <vector>
#include <string>
#include "stdafx.h"
#include "Node.h" 	
#include "OpCode.h"
#include "Type.h"
// Binary node
#include "Goal.h"
#include "MainClass.h"
#include "Add.h"
#include "Subtract.h"
#include "Multiply.h"
#include "And.h" 
#include "LessThan.h"
#include "Assignment.h"
#include "ClassDeclarationList.h"
#include "MethodDeclarationList.h"
#include "MethodDeclaration.h"
#include "StatementList.h"
#include "ExpressionList.h"
// Unary node
#include "Not.h" 
#include "PrintlnStatement.h"
#include "Variable.h"
#include "ClassDeclaration.h"
#include "NewArray.h"
#include "ArrayLengthExpression.h"
// Ternary node
#include "IfStatement.h"
#include "WhileStatement.h"
#include "ArrayAssignment.h"
#include "FunctionCall.h"
//Nullary node
#include "ConstantInteger.h"
#include "ConstantBoolean.h"
#include "ThisExpression.h"
#include "NewExpression.h"

// Factory 
#include "ArithmeticOpFactory.h"
#include "RelationalOpFactory.h"

#include "Symbol.h"
#include "SymbolTable.h"

#include "mj_tab.h"
// #include "YaccCompatible.h"

using namespace std;

extern char yytext[];
extern int column;
extern int line_no;

int yylexical();
int yylex(void)
{
    return yylexical();
}
void yyerror(char const *s);

// extern YYSTYPE yylval;

bool yyIntegratedSymbolTable = true;
SymbolTable yySymbolTable = SymbolTable();
Node* yyHeader = NULL;

vector<Symbol*>* SetAllType(Symbol*, vector<Symbol*>*);

%}

%token <tokenval> Class 1
%token <tokenval> Public 2
%token <tokenval> Static 3
%token <tokenval> Void 4
%token <tokenval> Main 5
%token <tokenval> String 6
%token <tokenval> Extends 7
%token <tokenval> Return 8
%token <tokenval> Integer 9 
%token <tokenval> Boolean 10 
%token <tokenval> If 11
%token <tokenval> Else 12
%token <tokenval> While 13
%token <tokenval> Println 14
%token <tokenval> ArrayLength 15 
%token <tokenval> True 16
%token <tokenval> False 17
%token <tokenval> This 18
%token <tokenval> And 19
%token <tokenval> New 20
%token <tokenstr> Id 21 //
%token <tokenstr> Number 22 //

%right '='
%left '{'
%left '['
%left And
%left '+' '-'
%left '*'
%left '.'
%left '!'
%nonassoc '<'

%start Goal

%type <node> Goal
%type <node> MainClass
%type <symbol> Identifier
%type <node> ClassDeclarationList
%type <node> ClassDeclaration
%type <symbolTable> VarDeclarationList
%type <symbol> VarDeclaration
%type <node> MethodDeclarationList
%type <node> MethodDeclaration
%type <symbolList> ParameterList
%type <type_t> Type
%type <node> StatementList
%type <node> Statement
%type <node> ExpressionList
%type <node> Expression
%type <node> variable


/*
%code requires
{
    #include "YaccCompatible.h"
}
%union {
    int tokenval;
    char* tokenstr;
    OpCode_t opCode;
    vector<Symbol*>* symbolList;
    Symbol* symbol;
    Type_t type_t;
    SymbolTable* symbolTable;
    Node* node;
}
*/

%%

Goal
    :   MainClass ClassDeclarationList      
        { 
	    yyHeader  = new Goal($1, $2);	
	    printf("OK\n"); 	
	}
    ;

MainClass
    :   Class Identifier '{' Public Static Void Main '(' String '[' ']' Identifier ')' '{' Statement '}' '}' {$$ = new MainClass($2 -> id, $15);} 
    ;

ClassDeclarationList
    :   ClassDeclaration ClassDeclarationList {$$ = new ClassDeclarationList($1, $2);}
    |   {$$ = NULL;}
    ;

ClassDeclaration
   :   Class Identifier '{' VarDeclarationList MethodDeclarationList '}' 
        {            
            Symbol* classSymbol = new Symbol($2 -> id, UNDEFINED, line_no);
            vector<Symbol*>* para = new vector<Symbol*>();
            for(int i = 0; i < $4 -> Size(); i++)
            {                
	        (*para).push_back($4 -> GetSymbol(i));
            }
            classSymbol -> parameters = para;
            yyIntegratedSymbolTable &= ($4) -> Insert(classSymbol);
            yyIntegratedSymbolTable &= InsertInto($5 -> GetMethodsSymbolTable(), $4);
            classSymbol -> symbolTable = $4;            
            yyIntegratedSymbolTable &= yySymbolTable.Insert(classSymbol);
            $$ = new ClassDeclaration($2 -> id, $5); // (class name, MethodDeclarationList)
        }
    |   Class Identifier '{' MethodDeclarationList '}' 
        {          
            Symbol* classSymbol = new Symbol($2 -> id, UNDEFINED, line_no);
            yyIntegratedSymbolTable &= ($4 -> GetMethodsSymbolTable()) -> Insert(classSymbol);          
            classSymbol -> symbolTable = $4 -> GetMethodsSymbolTable();            
            yyIntegratedSymbolTable &= yySymbolTable.Insert(classSymbol);
            $$ = new ClassDeclaration($2 -> id, $4); // (class name, MethodDeclarationList)
        }
    |   Class Identifier Extends Identifier '{' VarDeclarationList MethodDeclarationList '}' 
        {           
            Symbol* classSymbol = new Symbol($2 -> id, CLASS_T, line_no);
            vector<Symbol*>* para = new vector<Symbol*>();
            for(int i = 0; i < $6 -> Size(); i++)
            {                
	        (*para).push_back($6 -> GetSymbol(i));
            }
            classSymbol -> parameters = para;
            yyIntegratedSymbolTable &= ($6) -> Insert(classSymbol);
            yyIntegratedSymbolTable &= InsertInto($7 -> GetMethodsSymbolTable(), $6);
            yyIntegratedSymbolTable &= InsertInto((yySymbolTable.GetSymbol($4 -> id)) -> symbolTable, $6);
            classSymbol -> symbolTable = $6;            
            yyIntegratedSymbolTable &= yySymbolTable.Insert(classSymbol);
            $$ = new ClassDeclaration($2 -> id, $7); // (class name, MethodDeclarationList)   
        }
    |   Class Identifier Extends Identifier '{' MethodDeclarationList '}' 
        {            
            Symbol* classSymbol = new Symbol($2 -> id, CLASS_T, line_no);
            yyIntegratedSymbolTable &= ($6 -> GetMethodsSymbolTable()) -> Insert(classSymbol);           
            yyIntegratedSymbolTable &= InsertInto((yySymbolTable.GetSymbol($4 -> id)) -> symbolTable, $6 -> GetMethodsSymbolTable());
            classSymbol -> symbolTable = $6 -> GetMethodsSymbolTable();            
            yyIntegratedSymbolTable &= yySymbolTable.Insert(classSymbol);
            $$ = new ClassDeclaration($2 -> id, $6); // (class name, MethodDeclarationList)        
        }
    ;


VarDeclarationList
    :   VarDeclaration 
        {
	    SymbolTable* varSymbolTable = new SymbolTable();
	    yyIntegratedSymbolTable &= varSymbolTable -> Insert($1);  /* SymbleTable::Insert(Symbol* symbol) */
	    $$ = varSymbolTable;
	}
    |   VarDeclarationList VarDeclaration 
        {
	    SymbolTable* varSymbolTable = $1;
            yyIntegratedSymbolTable &= varSymbolTable -> Insert($2);  
	    $$ = varSymbolTable;
	}
    ;	

VarDeclaration
    :   Type Identifier ';' {$$ = new Symbol($2 -> id, $1, line_no);}  /* Symbol::Symbol(string id, Type_t type, int declaredLine) */
    ;

MethodDeclarationList
    :   MethodDeclaration MethodDeclarationList 
        {
            SymbolTable* symbolTable;
            if($2 != NULL)
                symbolTable = $2 -> GetMethodsSymbolTable();
            else
                symbolTable = new SymbolTable();            
	    
            yyIntegratedSymbolTable &= symbolTable -> Insert($1 -> GetSymbol());
	    MethodDeclarationList* methods = new MethodDeclarationList($1, $2);
	    methods -> SetMethodsSymbolTable(symbolTable);
	    $$ = methods;
	}
    |   {$$ = NULL;}
    ;

MethodDeclaration
    :   Public Type Identifier '(' ParameterList ')' '{' VarDeclarationList StatementList Return Expression ';' '}'
        {
	    Symbol* methodSymbol = new Symbol($3 -> id, $2, line_no);
            yyIntegratedSymbolTable &= ($8) -> Insert(methodSymbol); // Insert symbol(string method_name, Type_t return_type, int declaredLine) to VarDeclarationList(SymbolTable)
            yyIntegratedSymbolTable &= ($8) -> Insert($5); // Insert vector<Symbol*>* to VarDeclarationList(symbolTable)
            MethodDeclaration* method = new MethodDeclaration($3 -> id, $9, $11); // (Indentifier, StatementList, Expression)
            methodSymbol -> parameters = $5;
	    methodSymbol -> symbolTable = $8;	   
	    method -> SetSymbol(methodSymbol);
	    $$ = method;
	}
    |   Public Type Identifier '(' ParameterList ')' '{' StatementList Return Expression ';' '}'
        {
	    Symbol* methodSymbol = new Symbol($3 -> id, $2, line_no);
	    SymbolTable* symbolTable = new SymbolTable();
            yyIntegratedSymbolTable &= symbolTable -> Insert(methodSymbol);
	    yyIntegratedSymbolTable &= symbolTable -> Insert($5);
            MethodDeclaration* method = new MethodDeclaration($3 -> id, $8, $10);
            methodSymbol -> parameters = $5;
	    methodSymbol -> symbolTable = symbolTable;
	    method -> SetSymbol(methodSymbol);
	    $$ = method;
	}
    ;

ParameterList
    :   Type Identifier 
        {
	    vector<Symbol*>* para = new vector<Symbol*>();
	    (*para).push_back(new Symbol($2 -> id, $1, line_no));
	    $$ = para;
	} 
    |   Type Identifier ',' ParameterList 
        {
            vector<Symbol*>* para = $4;
	    (*para).push_back(new Symbol($2 -> id, $1, line_no));
	    $$ = para;
	}
    |   {$$ = NULL;}
    ;

Type
    :   Integer '[' ']' {$$ = ARRAY_T;}
    |   Boolean {$$ = BOOL_T;}  /* {$$ = new Symbol("", BOOL_T);} */
    |   Integer {$$ = INTEGER_T;}  /* {$$ = new Symbol("", INTEGER_T);} */
    |   Identifier {$$ = CLASS_T;}
    ;

StatementList
    :   Statement StatementList {$$ = new StatementList($1, $2);}
    |   {$$ = NULL;}	
    ;

Statement
    :   '{' StatementList '}' {$$ = $2;}
    |   If '(' Expression ')' Statement Else Statement {$$ = new IfStatement($3, $5, $7);}
    |   While '(' Expression ')' Statement {$$ = new WhileStatement($3, $5);}
    |   Println '(' Expression ')' ';' {$$ = new PrintlnStatement($3);}
    |   variable '=' Expression ';' {$$ = new Assignment($1, $3);}
    |   variable '[' Expression ']' '=' Expression ';' {$$ = new ArrayAssignment($1, $3, $6);}
    ;

ExpressionList
    :   Expression {$$ = new ExpressionList($1, NULL);}
    |   Expression ',' ExpressionList {$$ = new ExpressionList($1, $3);}
    |   {$$ = NULL;}
    ;

Expression
    :   Expression And Expression {$$ = RelationalOpFactory::CreateRelationalOpNode(AND_OP, $1, $3);}
    |   Expression '<' Expression {$$ = RelationalOpFactory::CreateRelationalOpNode(LESS_THAN_OP, $1, $3);}
    |   Expression '+' Expression {$$ = ArithmeticOpFactory::CreateArithmeticOpNode(ADD_OP, $1, $3);}
    |   Expression '-' Expression {$$ = ArithmeticOpFactory::CreateArithmeticOpNode(SUBTRACT_OP, $1, $3);}
    |   Expression '*' Expression {$$ = ArithmeticOpFactory::CreateArithmeticOpNode(MULTIPLY_OP, $1, $3);}
    |   Identifier '[' Expression ']' {$$ = new Variable($1 -> id, $3);}
    |   Expression '.' ArrayLength {$$ = new ArrayLengthExpression($1);}
    |   Expression '.' Identifier '(' ExpressionList ')' {$$ = new FunctionCall($1, $3 -> id, $5);} 
    |   Number {$$ = new ConstantInteger($1);}
    |   True {$$ = new ConstantBoolean(true);}
    |   False {$$ = new ConstantBoolean(false);}
    |   variable {$$ = $1;}  
    |   This {$$ = new ThisExpression(); }
    |   New Integer '[' Expression ']' {$$ = new NewArray($4);}
    |   New Identifier '(' ')' {$$ = new NewExpression($2 -> id);}
    |   '!' Expression {$$ = new Not($2);}
    |   '(' Expression ')' {$$ = $2;}
    ;

variable
    :   Identifier {$$ = new Variable($1 -> id, NULL);}
    ;
Identifier
    :   Id 
        {
            $$ = new Symbol($1, UNDEFINED, line_no);            
        }
    ;

%%
vector<Symbol*>* SetAllType(Symbol* type, vector<Symbol*>* symbols)
{
    for(int i = 0; i < symbols -> size(); i++)
    {
        (*symbols)[i] -> type = type -> type;
	//(*symbols)[i] -> dimensions = type -> dimensions;
    }
    return symbols;
}
void yyerror(char const *s) {
    fprintf(stderr, "line %d: %s\n", line_no, s);
}
/*
int main(void) {
    yyparse();
    return 0;
}
*/
