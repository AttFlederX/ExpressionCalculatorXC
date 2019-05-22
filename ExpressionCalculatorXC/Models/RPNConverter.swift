//
//  RPNConverter.swift
//  ExpressionCalculatorXC
//
//  Created by Dmytro on 5/20/19.
//  Copyright © 2019 AttFlederX. All rights reserved.
//

class RPNConverter
{
    enum AssocType { case Left, Right };
    
    static func getPrecedence(_ op: String) -> Int {
        if (op == "+" || op == "-") { return 2; }
        if (op == "*" || op == "/") { return 3; }
        if (op == "^") { return 4; }
        return -1;
    }
    
    static func getAssocType(_ op: String) -> AssocType {
        if (op == "^") { return AssocType.Right; }
        else { return AssocType.Left; }
    }
    
    /// <summary>
    /// Converts the input expression into reverse Polish notation using the shunting-yard algorithm
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    static func convert(_ input: [String]) -> [String]? {
        var stackTop: String
        var opStack = [String]();
        var output = [String]();
        
        for token in input {
            if Double(token) != nil { // if token is a real number
                output += [token];
            }
            else if (OpList.arithOpList.contains(token)) { // if token is an operator
            
                if (opStack.count > 0) { // if the operator stack is empty, the Peek method will throw an exception
            
                    stackTop = opStack.last!; // top of the stack
                    
                    while (getPrecedence(stackTop) >= getPrecedence(token) &&
                        getAssocType(stackTop) == AssocType.Left) {
                        output += [opStack.removeLast()];
                        if (opStack.count > 0) { // if the operator stack is empty, the Peek method will throw an exception
                            stackTop = opStack.last!
                        }
                        else {
                            break;
                        }
                    }
                }
                
                opStack += [token];
            }
            else if (OpList.funcOpList.contains(token) || token == "(") {
                opStack += [token];
            }
            else if (token == ")") {
                // add all operators up to the left parenthesis into the output
                while (opStack.last! != "(") {
                    output += [opStack.removeLast()];
                }
                opStack.removeLast(); // pops the "("
            
                while (opStack.count > 0 && OpList.funcOpList.contains(opStack.last!)) { // pop all remainig functions
                    output += [opStack.removeLast()];
                }
            }
        }
        
        while (opStack.count > 0) { // pop all remaining operators
        
            stackTop = opStack.last!;
            if (OpList.arithOpList.contains(stackTop) ||
                OpList.funcOpList.contains(stackTop)) {
                output += [opStack.removeLast()];
            }
            else {
                return nil; // invalid expression
            }
        }
        
        return output;
    }
}
