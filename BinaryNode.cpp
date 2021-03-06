#include <cstdlib>
#include "stdafx.h"
#include "Node.h"
#include "BinaryNode.h"

BinaryNode::BinaryNode(Node* a, Node* b) : Node()
{
    children.push_back(a);
    children.push_back(b);
    type = UNDEFINED;
}
void BinaryNode::SetSymbolTable(SymbolTable* gSymTable, SymbolTable* lSymTable)
{
    Node::SetSymbolTable(gSymTable, lSymTable);
    if(children[0] != NULL)
        children[0] -> SetSymbolTable(gSymTable, lSymTable);
    if(children[1] != NULL)
        children[1] -> SetSymbolTable(gSymTable, lSymTable);
}
bool BinaryNode::SemanticCheck()
{
    bool result = true;
    if(children[0] != NULL)
        result &= children[0] -> SemanticCheck();
    if(children[1] != NULL)
        result &= children[1] -> SemanticCheck();
    return result;
}
bool BinaryNode::Initialize()
{
    bool result = true;
    if(children[0] != NULL)
        result &= children[0] -> Initialize();
    if(children[1] != NULL)
        result &= children[1] -> Initialize();
    return result;
}
