#pragma once
#include <vector>
#include <string>
#include "Type.h"
#include "ArrayRange.h"
#include "SymbolTable.h"
// #include "llvm/Value.h"

using namespace std;

// class SymbolTable;

class Symbol
{
public:
    Symbol(string, Type_t);
    Symbol(string, Type_t, int);
    string id;
    Type_t type;
    vector<Symbol*>* parameters;
    vector<ArrayRange_t> dimensions;
    SymbolTable* symbolTable;
    int declaredLine;
    // llvm::Value* value;
};