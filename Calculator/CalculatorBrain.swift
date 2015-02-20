//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Egor on 2/18/15.
//  Copyright (c) 2015 EgorF. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    // Printable is a protocol not inheretence
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double) // pass function as a parameter
        case BinaryOperation(String, (Double, Double) -> Double) // function is no different than a data type
        
        var description: String {
            get {
                switch self
                {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    // var opStack = Array<Op>()
    // same thing below:
    private var opStack = [Op]()
    
    
    //Dictionary for operations
    //var knownOps = Dictionary<String, Op>() // specify the operations with math symbols
    private var knownOps = [String:Op]()
    
    // Calculator constructor
    init() {
        
        func learnOp(op: Op)
        {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("+") { $0 + $1 })
        learnOp(Op.BinaryOperation("×", *)) // same thing as the others
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        
        // knownOps["√"] = Op.UnaryOperation("√") { sqrt($0) } // same thing:
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
    }
    
    // all parameters except class instances are passed by value with an implicit let
    // func evaluate(var ops: [Op]) -> (result: Double?, remainingOps: [Op]) // tuple return
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) // tuple return
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
                
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result
                    {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol] // Dictionary always returns an optional
        {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func clear()
    {
        opStack = [Op]()
        println("OpStack array cleared\nnew value is \(opStack)")
    }
}