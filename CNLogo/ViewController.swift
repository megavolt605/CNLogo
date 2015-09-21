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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var animationSpeedSlider: UISlider!

    var currentIndex = 0
    var duration = 0.0
    var executing = false
    var paused = false
    
    var tableViewDataSource: CNProgramTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        animationSpeedSlider.value = Float(duration)
        
        fieldView.opaque = false
        fieldView.backgroundColor = UIColor.clearColor()
        
        updateButtons()

        func makeExprFromValue(value: CNValue) -> CNExpression {
            return CNExpression(source: [CNExpressionParseElement.Value(value: value)])
        }
        
        /*
            sides = 20
            length = 400 / sides
            angle = 360 / sides
            Turtle.Speed = 9
            For j = 1 To 20
                For i = 1 To sides
                    Turtle.Move(length)
                    Turtle.Turn(angle)
                EndFor
                Turtle.Turn(18)
            EndFor
        */

        program = CNProgram(statements: [
            CNStatementVar(name: "sides", parameters: [makeExprFromValue(CNValue.int(value: 20))]),
            CNStatementVar(name: "length", parameters: [CNExpression(source: [
                CNExpressionParseElement.Value(value: CNValue.double(value: 400.0)),
                CNExpressionParseElement.Div,
                CNExpressionParseElement.Variable(name: "sides")
            ])]),
            CNStatementVar(name: "angle", parameters: [CNExpression(source: [
                CNExpressionParseElement.Value(value: CNValue.double(value: 360.0)),
                CNExpressionParseElement.Div,
                CNExpressionParseElement.Variable(name: "sides"),
            ])]),
            CNStatementRepeat(
                parameters: [makeExprFromValue(CNValue.int(value: 19))],
                statements: [
                    CNStatementRepeat(
                        parameters: [CNExpression(source: [
                            CNExpressionParseElement.Variable(name: "sides"),
                            CNExpressionParseElement.Sub,
                            CNExpressionParseElement.Value(value: CNValue.int(value: 1))
                        ])],
                        statements: [
                            CNStatementForward(parameters: [CNExpression(source: [
                                CNExpressionParseElement.Variable(name: "length")
                            ])]),
                            CNStatementRotate(parameters: [CNExpression(source: [
                                CNExpressionParseElement.Variable(name: "angle")
                            ])])
                        ]
                    ),
                    CNStatementRotate(parameters: [makeExprFromValue(CNValue.double(value: 18.0))])
                ]
            )
        ])

        do {
            try program.prepare()
        } catch let error as CNError {
            print("Prepare ERROR: \(error.description)")
        } catch {
            print("Unknown error")
        }

        tableViewDataSource = CNProgramTableViewDataSource(program: program)
        tableView.reloadData()
        tableView.dataSource = tableViewDataSource
    }

    @IBAction func startButtonTouchUpInside(sender: AnyObject) {
        if executing {
            executing = false
            updateButtons()
        } else {
            paused = false
            executing = true
            updateButtons()
            do {
                fieldView.clear()
                program.clear()
                program.player.startState.position = CGPointMake(CGRectGetMidX(fieldView.bounds), CGRectGetMidY(fieldView.bounds))
                try program.execute()
                visualizeResult()
            } catch let error as CNError {
                print("Execute ERROR: \(error.description)")
            } catch {
                print("Unknown error")
            }
        }
    }

    @IBAction func pauseButtonTouchUpInside(sender: AnyObject) {
        paused = !paused
        updateButtons()
        if !paused {
            visualizeStep()
        }
    }
    
    @IBAction func animationSurationSliderValueChanged(sender: AnyObject) {
        duration = Double(animationSpeedSlider.value) / 100.0
    }
    
    func updateButtons() {
        pauseButton.setTitle(paused ? "Continue" : "Pause", forState: .Normal)
        startButton.setTitle(executing ? "Stop" : "Start", forState: .Normal)
        pauseButton.enabled = executing

        startButton.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        startButton.layer.borderColor = UIColor(red: 0.0, green: 0.65, blue: 0.0, alpha: 1.0).CGColor
        startButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startButton.layer.borderWidth = 2.0
        startButton.layer.cornerRadius = 4.0
        
        if pauseButton.enabled {
            pauseButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
            pauseButton.layer.borderColor = UIColor(red: 0.65, green: 0.65, blue: 0.0, alpha: 1.0).CGColor
            pauseButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            pauseButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            pauseButton.layer.borderColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.0).CGColor
            pauseButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        pauseButton.layer.borderWidth = 2.0
        pauseButton.layer.cornerRadius = 4.0
        
        animationSpeedSlider.enabled = !executing
        
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
            if executing && !paused {
                fieldView.makeSnapshot()
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
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.visualizeStep()
                                }
                            }
                        } else {
                            fieldView.addPlayerMoveWithItem(item, fromPoint: fromPoint, toPoint: toPoint, duration: duration) { done in
                                self.currentIndex++
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.visualizeStep()
                                }
                            }
                        }
                    case let .Rotate(fromAngle, toAngle):
                        fieldView.addPlayerRotationWithItem(item, fromAngle: fromAngle, toAngle: toAngle, duration: duration) { done in
                            self.currentIndex++
                            dispatch_async(dispatch_get_main_queue()) {
                                self.visualizeStep()
                            }
                        }
                    case .TailState, .Color, .Width:
                        currentIndex++
                        shouldBreak = false
                        break
                    }
                    
                } while !shouldBreak && (currentIndex < program.executionHistory.history.count)
            }
        } else {
            fieldView.makeSnapshot(true)
            executing = false
            updateButtons()
        }
    }
    
}

