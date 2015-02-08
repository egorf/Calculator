//
//  ViewController.swift
//  Calculator
//
//  Created by Egor on 2/7/15.
//  Copyright (c) 2015 EgorF. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber = false // Bool inferred
    var operandStack = Array<Double>() // Array<Double> inferred
    // always have the label value converted to Double and put to the variable
    var displayValue: Double
    {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber
        {
            // crashes if display.text == nil
            display.text = display.text! + digit
        } else {
            display.text = digit;
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    @IBAction func operate(sender: UIButton)
    {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber
        {
            enter()
        }
        
        switch operation
        {
        case "×":
            performOperation({ (op1, op2) in return op1*op2 }) // operation args inferred by performOperation declaration

        case "÷":
            performOperation({ (op1, op2) in op1 / op2 })

        case "+":
            performOperation({ $0 + $1 })
        
        case "-":
            performOperation() { $0 - $1 }
            
        case "√":
            performOperation { sqrt($0) }

        default:
            break

        }
        
    }
    
    func performOperation(operation: (Double, Double) -> Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double) -> Double)
    {
        if operandStack.count >= 1
        {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
}






