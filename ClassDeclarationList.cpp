#include "stdafx.h"
#include "Node.h"
#include "ClassDeclarationList.h"
#include <string>

ClassDeclarationList::ClassDeclarationList(Node* a, Node* b) : BinaryNode(a, b)
{

}
void ClassDeclarationList::SetSymbleTable(SymbolTable* gSymTable, SymbolTable* lSymTable)
{
    BinaryNode::SetSymbolTable(gSymTable, lSymTable);
}
void ClassDeclarationList::Accept(Visitor* visitor)
{
    visitor -> Visit(this);
}
bool ClassDeclarationList::SemanticCheck()
{
    return BinaryNode::SemanticCheck();
}
bool ClassDeclarationList::Initialize()
{
    return BinaryNode::Initialize();
}
