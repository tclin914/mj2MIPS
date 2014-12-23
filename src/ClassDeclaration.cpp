#include "stdafx.h"
#include "Node.h"
#include "ClassDeclaration.h"
#include <string>

const char static const char MISSING_CLASS_ERROR[] = "The method '%s' got error.";
ClassDeclaration::ClassDeclaration(string id, Node* a) : UnaryNode(a) // (class name, MethodDeclaration)
{
    this -> id = id;
}
void ClassDeclaration::SetSymbolTable(SymbolTable* gSymTable, SymbolTable* lSymTable)
{
    classEntry = gSymTable -> GetSymbol(id);
    if(classEntry == NULL)
        Node::ErrorReport(MISSING_CLASS_ERROR, id.c_str());
    UnaryNode::SetSymbolTable(gSymTable, classEntry -> symbolTable);
}
void ClassDeclaration::Accept(Visitor* visitor)
{
    visitor -> Visit(this);
}
bool ClassDeclaration::SemanticCheck()
{
    return UnaryNode:SemanticCheck();
}
bool ClassDeclaration::Initialize()
{
    return UnaryNode::Initialize();
}
Symbol* ClassDeclaration::GetClassSymbol()
{
    return classEntry;
}
