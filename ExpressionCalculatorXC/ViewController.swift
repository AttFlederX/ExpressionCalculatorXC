//
//  ViewController.swift
//  ExpressionCalculatorXC
//
//  Created by Dmytro on 5/20/19.
//  Copyright © 2019 AttFlederX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var isDecimalPointReceived = false; // prevents more than one decimal point from appearing in a single number
    var initialState = true;
    var resultState = false;
    
    var memValue: Double = 0; // memory storage
    
    // prevents operators from being typed in a row
    var isOperatorLastReceived: Bool {
        if let text = inputTextField.text, text.count > 0 {
            return text.hasSuffix(" ")
        }
        return true;
    }

    @IBOutlet weak var inputTextField: UITextField!
    
    /// <summary>
    /// Resets the textboxes if the program is in its initial state or result display state
    /// </summary>
    func ResetState()
    {
        if (initialState || resultState) { // if the textbox contains the default value
        
            inputTextField.text = "";
            initialState = false;
            resultState = false;
        }
    }
    
    /// <summary>
    /// Resets the program to its initial state
    /// </summary>
    func ClearInput()
    {
        inputTextField.text = "0.";
    
        isDecimalPointReceived = false;
        initialState = true;
        resultState = false;
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /// <summary>
    /// Handles the 1 through 9 digit buttons
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    @IBAction func digitTouchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            // if the first entered digit was not zero
            if (!(text.hasSuffix(" 0")) && !(text.hasSuffix("0") && text.count == 1)) {
                
                ResetState();
                inputTextField.text! += (sender.titleLabel?.text)!;
            }
        }
    }
    
    /// <summary>
    /// Handles the +, -, * and / operators
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    @IBAction func operatorTouchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            if (!isOperatorLastReceived && !resultState && !text.hasSuffix("( ") &&
                text.last != ".") // can't have two operators in a row
            {
                
                inputTextField.text! += " \(sender.titleLabel!.text!) "; // frame the operator into spaces for Split function
                //exp.Append(b.Text);
                isDecimalPointReceived = false;
            }
        }
    }
    
    /// <summary>
    /// Equals button handling(result calculation & display)
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    @IBAction func equalsTouchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            // converts the expression into reverse Polish notation and immidiately calculates the result
            let result = RPNCalculator.calculate(exp: RPNConverter.convert(text.split(separator: " ").map(String.init))!);
            
            if (result == nil) {
                inputTextField.text = "Error";
            }
            else {
                inputTextField.text = String(format: "%f", result!)
            }
            resultState = true;
        }
    }
    
    @IBAction func zeroTouchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            //if the first digit of a number was not 0
            if (!text.hasSuffix(" 0") && !(text.hasSuffix("0") && text.count == 1))
            {
                ResetState();
                
                inputTextField.text! += "0";
            }
        }
    }
    
    @IBAction func decimalTouchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            // can't have multiple decimal points in a single number or in the beginning of a number
            if (!isOperatorLastReceived && !text.hasSuffix("( ") && !isDecimalPointReceived)
            {
                inputTextField.text! += ".";
                isDecimalPointReceived = true;
            }
        }
    }
    
    @IBAction func plusMinusTouchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            if (isOperatorLastReceived || text.hasSuffix("negate ( "))
            {
                ResetState();
                
                if (text.hasSuffix("negate ( ")) // changes back to positive
                {
                    inputTextField.text = String(text.dropLast(9))
                    if (inputTextField.text!.count == 0) {
                        ClearInput();
                    }
                }
                else
                {
                    inputTextField.text! += "negate ( ";
                }
            }
        }
    }
    
    @IBAction func leftParenthesisTuchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            if (isOperatorLastReceived || text.hasSuffix("( "))
            {
                ResetState();
                
                inputTextField.text! += "( ";
                //isOperatorLastReceived = false;
            }
        }
    }
    
    @IBAction func rightParenthesisTouchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            if (!isOperatorLastReceived && text.contains("(") && text.last != ".")
            {
                inputTextField.text! += " )";
            }
        }
    }
    
    @IBAction func clearTouchUpInside(_ sender: UIButton) {
        ClearInput();
    }
    
    @IBAction func backspaceTouchUpInside(_ sender: UIButton) {
        if let text = inputTextField.text {
            if (!initialState && text.count > 0)
            {
                if (text.hasSuffix("( ") || text.hasSuffix(" )"))
                {
                    inputTextField.text = String(text.dropLast(2))
                }
                else if (text.hasSuffix(".") || text.hasSuffix("-"))
                {
                    inputTextField.text = String(text.dropLast(1))
                    isDecimalPointReceived = false;
                }
                else if (isOperatorLastReceived)
                {
                    while (text.count > 0 && CharacterSet.decimalDigits.contains((text.last?.unicodeScalars.first)!) &&
                        !text.hasSuffix(" )") && !text.hasSuffix("( ")) // remove the operator and the spaces
                    {
                        inputTextField.text = String(text.dropLast(1))
                    }
                }
                else
                {
                    inputTextField.text = String(text.dropLast(1))
                }
                
                if (inputTextField.text!.count == 0) // if the input field is empty after the backspace
                {
                    ClearInput();
                }
            }
        }
    }
}

