#pragma once
#include "UnaryNode.h"
#include <string>

using namespace std;

class ClassDeclaration : public UnaryNode
{
public:
    ClassDeclaration(string, Node*); // (class name, MethodDeclaration)
    void SetSymbolTable(SymbolTable*, SymbolTable*);
    void Accept(Visitor*);
    bool SemanticCheck();
    bool Initialize();
    
    Symbol* GetClassSymbol();
private:
    Symbol* classEntry;
    string id;
    static const char MISSING_CLASS_ERROR[];
};  

