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
    
    var brain = CalculatorBrain()
    
    var userIsInTheMiddleOfTypingANumber = false // Bool inferred
    var floatingPointUsed = false
    
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
        let pressedButton = sender.currentTitle!
        var digit: String
        var needEnterFlag: Bool = false
        
        switch pressedButton
        {
            case "•":
                digit = "."
            
            case "π":
                digit = "\(M_PI)"
                needEnterFlag = true
            
            default:
                digit = pressedButton
        }

        let thisDigitContainsFloatingPoint = digit.rangeOfString(".") != nil
        
        println("Button pressed \(digit)")
        
        if userIsInTheMiddleOfTypingANumber
        {
            // crashes if display.text == nil
            if !floatingPointUsed || !thisDigitContainsFloatingPoint
            {
                println("FlP_used \(floatingPointUsed), thisDigitContainsPoint \(thisDigitContainsFloatingPoint)")
                display.text = display.text! + digit
            }
        } else {
            display.text = digit;
            userIsInTheMiddleOfTypingANumber = true
        }
        
        // check if we used a point in the number
        if thisDigitContainsFloatingPoint
        {
            floatingPointUsed = true
            println("The pressed button contains a point!")
        }
        
        if needEnterFlag
        {
            enter()
        }
    }
    
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false
        floatingPointUsed = false
        if let result = brain.pushOperand(displayValue)
        {
            displayValue = result
        } else {
            displayValue = 0 // broken result
        }
    }
    
    @IBAction func operate(sender: UIButton)
    {
        if userIsInTheMiddleOfTypingANumber
        {
            enter()
        }
        
        if let operation = sender.currentTitle
        {
            if let result = brain.performOperation(operation)
            {
                displayValue = result
            } else {
                displayValue = 0 // broken result should be error message
            }
        }
    }
    
    // let's clear the stack and the result
    @IBAction func clear(sender: UIButton)
    {
        displayValue = 0.0
        brain.clear()
    }
    
    
}






