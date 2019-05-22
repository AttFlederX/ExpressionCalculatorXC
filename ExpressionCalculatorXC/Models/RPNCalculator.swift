//
//  RPNCalculator.swift
//  ExpressionCalculatorXC
//
//  Created by Dmytro on 5/20/19.
//  Copyright © 2019 AttFlederX. All rights reserved.
//

import Foundation

class RPNCalculator
{
    /// <summary>
    /// Calculates the value of an expression written in the reverse Polish notation.
    /// The return type is nullable to enable the function to return null if the calculation has failed.
    /// angleCoef determines the unit in which to calculatse trigonometric functions
    /// </summary>
    /// <param name="exp"></param>
    /// <param name="angleCoef"></param>
    /// <returns></returns>
    static func calculate(exp: [String], angleCoef: Double = 1) -> Double? {
        let res: Double;
        var op1: Double
        var op2 : Double;
    
        var operandStack = [Double]()
    
        for token in exp {
            if let conv = Double(token) { // if token is a real number
                operandStack += [conv];
            }
            else if (OpList.arithOpList.contains(token)) { // if token is an arithmetic operator
            
                op1 = operandStack.removeLast();
                op2 = operandStack.removeLast();
            
                switch token {
                    case "+":
                        operandStack += [op2 + op1];
                        break;
                    case "-":
                        operandStack += [op2 - op1];
                        break;
                    case "*":
                        operandStack += [op2 * op1];
                        break;
                    case "/":
                        if (op1 == 0) { return nil; }
                        operandStack += [op2 / op1];
                        break;
                    case "^":
                        operandStack += [pow(op2, op1)];
                        break;
                    default:
                        break;
                }
            }

            else if (OpList.funcOpList.contains(token)) { // if token is a function operator
            
                op1 = operandStack.removeLast();
            
                switch token
                {
                    case "sin":
                        operandStack += [sin(angleCoef * op1)];
                        break;
                    case "cos":
                        operandStack += [cos(angleCoef * op1)];
                        break;
                    case "tan":
                        if (cos(op1) == 0) { return nil; }
                        operandStack += [tan(angleCoef * op1)];
                        break;
                
                    case "log":
                        if (op1 == 0) { return nil; }
                        operandStack += [log10(angleCoef * op1)];
                        break;
                    case "ln":
                        if (op1 == 0) { return nil; }
                        operandStack += [log(angleCoef * op1)];
                        break;
                
                    case "sqrt":
                        if (op1 < 0) { return nil; }
                        operandStack += [sqrt(op1)];
                        break;
                
                    case "floor":
                        operandStack += [floor(op1)];
                        break;
                    case "ceil":
                        operandStack += [ceil(op1)];
                        break;
                    
                    case "negate":
                        operandStack += [-1 * op1];
                        break;
                    
                    default:
                        break;
                }
            }
        }
        
        res = operandStack.removeLast();
        
        if (operandStack.count > 0) {
            return nil;
        }
        else {
            return res;
        }
    }
}
