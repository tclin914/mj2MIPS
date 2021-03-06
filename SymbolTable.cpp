#include "stdafx.h"
#include "SymbolTable.h"
#include <string>
#include <string.h>

const char SymbolTable::DUPLICATED_SYMBOL_ERROR[] = "Duplicated symbol name '%s' at line %d\n";

// Insert symbol to symboltable.
bool SymbolTable::Insert(Symbol* symbol)
{
    int rank = Rank(symbol -> id);
    if(rank < symbols.size())
        if(strcmp(symbol -> id.c_str(), symbols[rank] -> id.c_str()) == 0)
	{
	    printf(DUPLICATED_SYMBOL_ERROR, symbol -> id.c_str(), symbol -> declaredLine);
	    return false;
	}
    symbols.insert(symbols.begin() + rank, 1, symbol);
    return true;
}
// Insert vector of symbols to symboltable.
bool SymbolTable::Insert(vector<Symbol*>* symbolVec)
{
    bool result = true;
    for(int i = 0; symbolVec != NULL && i < symbolVec -> size(); i++)
        result &= Insert((*symbolVec)[i]);
    return result;
}
Symbol* SymbolTable::GetSymbol(int index)
{
    return symbols[index];
}
Symbol* SymbolTable::GetSymbol(string id)
{
    int rank = Rank(id);
    if(rank < symbols.size())
        if(strcmp(id.c_str(), symbols[rank] -> id.c_str()) == 0)
	    return symbols[rank];
    return NULL;
}
// Return a position of symboltable to insert symbol.
int SymbolTable::Rank(string id)
{
    int left = 0, right = symbols.size() - 1;
    int rank = (left + right) / 2;
    for(; left <= right; rank = (left + right + 1) / 2)
    {
        int cmpResult = 0;
        if((cmpResult = strcmp(id.c_str(), symbols[rank] -> id.c_str())) > 0)
            left = rank + 1;
	else if(cmpResult < 0)
            right = rank - 1;
	else
            break;
    }
    return rank;
}
int SymbolTable::Size()
{
    return symbols.size();
}
// Insert symbols from src symboltable to target symboltable
bool InsertInto(SymbolTable* src, SymbolTable* target)
{
    bool result = true;
    int size = ((src != NULL) ? src -> Size() : 0);
    for(int i = 0; i < size; i++)
        result &= target -> Insert(src -> GetSymbol(i));
    return result;
}

bool Initial(SymbolTable* symbolTable)
{
 // TODO:   
}















