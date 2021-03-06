#include "stdafx.h"
#include "Node.h"
#include "ArithmeticOperation.h"

const char ArithmeticOperation::MISSING_OPERAND_ERROR[] = "The arithmetic operator lose (an) operand(s).";
const char ArithmeticOperation::WRONG_TYPE_ERROR[] = "Wrong element type";
const char ArithmeticOperation::NOT_INTEGER_EXCEPTION[] = "Getting a value from a integer node is not a integer exception occurs.";

ArithmeticOperation::ArithmeticOperation(Node* a, Node* b) : BinaryNode(a, b)
{

}
void ArithmeticOperation::SetSymbolTable(SymbolTable* gSymTable, SymbolTable* lSymTable)
{
    BinaryNode::SetSymbolTable(gSymTable, lSymTable);
}
bool ArithmeticOperation::SemanticCheck()
{
    return BinaryNode::SemanticCheck() & locallySemanticCheck();
}
bool ArithmeticOperation::Initialize()
{
    if(!BinaryNode::Initialize())
        return false;
    bool result = locallySemanticCheck();
    if(result)
        type = children[0] -> GetType();
    return result;
}
bool ArithmeticOperation::locallySemanticCheck()
{
    if(children[0] == NULL || children[1] == NULL)
    {
        Node::ErrorReport(MISSING_OPERAND_ERROR);
	return false;
    }     
    // Check whether type of two operands is equal and the type is integer.
    if((children[0] -> GetType() != children[1] -> GetType()) || (children[0] -> GetType() != INTEGER_T))
    {
        Node::ErrorReport(WRONG_TYPE_ERROR);
	return false;
    }
    return true;
}
bool ArithmeticOperation::IsEvaluable()
{
    if(children[0] != NULL && children[1] != NULL)
        return children[0] -> IsEvaluable() && children[1] -> IsEvaluable();
    return false;
}
int ArithmeticOperation::GetIntValue()
{
    if(!IsEvaluable())
        Node::GetIntValue(); // int Node::GetIntValue()
                             // {
	                     //     throw new exception();
	                     // }
    if(type != INTEGER_T)
        throw exception(/*NOT_INTEGER_EXCEPTION*/);
    return AGetIntValue();
}
