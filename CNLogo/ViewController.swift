//
//  ViewController.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright (c) 2015 Complex Numbers. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {

    @IBOutlet var fieldView: CNFieldView!

    var currentIndex = 0
    var duration = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        func makeExprFromValue(value: CNValue) -> CNExpression {
            return CNExpression(source: [CNExpressionParseElement.Value(value: value)])
        }
        
        
        program = CNProgram(statements: [
            CNStatementVar(name: "A", parameters: [makeExprFromValue(CNValue.double(value: 31.0))]),
            CNStatementRepeat(
                parameters: [makeExprFromValue(CNValue.int(value: 25))],
                statements: [
                    CNStatementPrint(parameters: [makeExprFromValue(CNValue.string(value: "!!!"))]),
                    CNStatementForward(parameters: [CNExpression(source: [
                        CNExpressionParseElement.BracketOpen,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 2.0)),
                        CNExpressionParseElement.Add,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 8.0)),
                        CNExpressionParseElement.BracketClose,
                        CNExpressionParseElement.Mul,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 5.1))
                    ])]),
                    CNStatementRotate(parameters: [CNExpression(source: [
                        CNExpressionParseElement.Value(value: CNValue.double(value: 360.0)),
                        CNExpressionParseElement.Div,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 20.0))
                        ])]),
                    CNStatementTailUp(),
                    CNStatementForward(parameters: [CNExpression(source: [
                        CNExpressionParseElement.Variable(name: "A")
                        ])]),
                    CNStatementRotate(parameters: [
                        CNExpression(source: [
                            CNExpressionParseElement.Value(value: CNValue.double(value: 360.0)),
                            CNExpressionParseElement.Div,
                            CNExpressionParseElement.Value(value: CNValue.double(value: 10.0))
                        ])
                    ]),
                    CNStatementTailDown()
                ] as [CNStatement]
            )
        ])
        program.player.startState.position = view.center
        try! program.prepare()
        try! program.execute()
        
        visualizeResult()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func visualizeResult() {
        currentIndex = 0
        visualizeStep()
    }
    
    func visualizeStep() {
        if currentIndex < program.executionHistory.history.count {
            var shouldBreak = true
            var rect = CGRectZero
            repeat {
                shouldBreak = true
                let item = program.executionHistory.history[currentIndex]
                switch item.type {
                case .Clear:
                    fieldView.clear()
                    currentIndex++
                    shouldBreak = false
                case let .Move(fromPoint, toPoint, _):
                    rect.origin = CGPointMake(min(fromPoint.x, toPoint.x), min(fromPoint.y, toPoint.y))
                    rect.size = CGSizeMake(max(fromPoint.x, toPoint.x), max(fromPoint.y, toPoint.y))
                    if item.playerState.tailDown {
                        fieldView.addStrokeWithItem(item, fromPoint: fromPoint, toPoint: toPoint, duration: duration) { done in
                            self.currentIndex++
                            self.visualizeStep()
                        }
                    } else {
                        fieldView.addPlayerMoveWithItem(item, fromPoint: fromPoint, toPoint: toPoint, duration: duration) { done in
                            self.currentIndex++
                            self.visualizeStep()
                        }
                    }
                case let .Rotate(fromAngle, toAngle):
                    fieldView.addPlayerRotationWithItem(item, fromAngle: fromAngle, toAngle: toAngle, duration: duration) { done in
                        self.currentIndex++
                        self.visualizeStep()
                    }
                case .TailState, .Color, .Width:
                    currentIndex++
                    shouldBreak = false
                    break
                }
                
            } while !shouldBreak && (currentIndex < program.executionHistory.history.count)
            //fieldView.setNeedsDisplayInRect(rect)
        } else {
            //visualizeTimer.invalidate()
        }
    }
    
}

