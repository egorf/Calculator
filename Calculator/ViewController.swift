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
}






