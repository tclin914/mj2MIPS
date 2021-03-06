#include "stdafx.h"
#include "Node.h"
#include "MainClass.h"
#include <string>

const char MainClass::MISSING_MAIN_CLASS_ERROR[] = "The class '%s' got error.";

MainClass::MainClass(string id, Node* a) : UnaryNode(a)
{
    this -> id = id;
}
void MainClass::SetSymbolTable(SymbolTable* gSymTable, SymbolTable* lSymTable)
{
    //mainclassEntry = gSymTable -> GetSymbol(id);
    //if(mainclassEntry == NULL)
        //Node::ErrorReport(MISSING_MAIN_CLASS_ERROR, id.c_str());
    UnaryNode::SetSymbolTable(gSymTable, lSymTable);
}
void MainClass::Accept(Visitor* visitor)
{
    visitor -> Visit(this);
}
bool MainClass::SemanticCheck()
{
    return UnaryNode::SemanticCheck();
}
bool MainClass::Initialize()
{
    return UnaryNode::Initialize();
}
/*
Symbol* MainClass::GetMainClassSymbol()
{
    return mainclassEntry;
}
*/
