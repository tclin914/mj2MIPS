#pragma once
#include "SymbolTable.h"

class Node;
class ClassDeclarationList;
class MethodDeclarationList;
class MethodDeclaration;
class StatementList;
class Assignment;
class And;
class LessThan;
class Add;
class Subtract;
class Multiply;
class Not;
class IfStatement;
class WhileStatement;
class MainClass;
class Variable;
class PrintlnStatement;
class Goal;
class ExpressionList;
class ConstantInteger;
class ConstantBoolean;
class ClassDeclaration;
class ArrayAssignment;
class ArrayLengthExpression;
class FunctionCall;
class ThisExpression;
class NewExpression;
class NewArray;


using namespace std;

class Visitor
{
public:
    virtual void Visit(ClassDeclarationList*) = 0;
    virtual void Visit(MethodDeclarationList*) = 0;
    virtual void Visit(MethodDeclaration*) = 0;
    virtual void Visit(StatementList*) = 0;
    virtual void Visit(Assignment*) = 0;
    virtual void Visit(And*) = 0;
    virtual void Visit(LessThan*) = 0;
    virtual void Visit(Add*) = 0;
    virtual void Visit(Subtract*) = 0;
    virtual void Visit(Multiply*) = 0;
    virtual void Visit(Not*) = 0;   
    virtual void Visit(IfStatement*) = 0;
    virtual void Visit(WhileStatement*) = 0;
    virtual void Visit(MainClass*) = 0;
    virtual void Visit(Variable*) = 0;
    virtual void Visit(PrintlnStatement*) = 0;
    virtual void Visit(Goal*) = 0;
    virtual void Visit(ExpressionList*) = 0;
    virtual void Visit(ConstantInteger*) = 0;
    virtual void Visit(ConstantBoolean*) = 0;
    virtual void Visit(ClassDeclaration*) = 0;
    virtual void Visit(ArrayAssignment*) = 0;
    virtual void Visit(ArrayLengthExpression*) = 0;
    virtual void Visit(FunctionCall*) = 0;
    virtual void Visit(ThisExpression*) = 0;
    virtual void Visit(NewExpression*) = 0;
    virtual void Visit(NewArray*) = 0;
    
    
    virtual void SetSymbolTable(SymbolTable*);
protected:
    SymbolTable* symbolTable;
private:
};
