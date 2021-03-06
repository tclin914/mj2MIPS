#pragma once
#include "TernaryNode.h"

using namespace std;

class ArrayAssignment : public TernaryNode
{
public:
    ArrayAssignment(Node*, Node*, Node*); //a[2] = 3 (a, 2, 3)
    void SetSymbolTable(SymbolTable* , SymbolTable*);
    void Accept(Visitor*);
    bool SemanticCheck();
    bool Initialize();
private:
    static const char MISSING_OPERAND_ERROR[];
    static const char UNASSIGNABLE_ERROR[];
    static const char WRONG_TYPE_ERROR[];
    static const char OUT_OF_INDEX_ERROR[];
    static const char MISSING_ARRAY_INDEX[];
};
