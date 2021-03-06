#include "stdafx.h"
#include "Node.h"
#include "NewExpression.h"

const char NewExpression::MISSING_CLASS_ERROR[] = "The class '%s' got error.";
NewExpression::NewExpression(string id) : NullaryNode()
{
    this -> id = id;
}
void NewExpression::SetSymbolTable(SymbolTable* gSymTable, SymbolTable* lSymTable)
{
    classEntry = gSymTable -> GetSymbol(id);       
    if(classEntry == NULL)
        Node::ErrorReport(MISSING_CLASS_ERROR, id.c_str());
    //UnaryNode::SetSymbolTable(gSymTable, classEntry -> symbolTable);
}
void NewExpression::Accept(Visitor* visitor)
{
    visitor -> Visit(this);
}
bool NewExpression::Initialize()
{    
    type = CLASS_T;
    return true;
}
Symbol* NewExpression::GetSymbol()
{     
   return classEntry;
}
/*
Symbol* NewExpression::GetSymbol(string id)
{
    Symbol* symbol = localSymbolTable -> GetSymbol(id);
    if(symbol == NULL)
        symbol = globalSymbolTable -> GetSymbol(id);
    return symbol;
}
*/

