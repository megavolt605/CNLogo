//
//  ViewController.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright (c) 2015 Complex Numbers. All rights reserved.
//

import UIKit
import CoreGraphics
import CNLogoCore

enum CNRunState: Int {
    case Stopped, Executing, Paused
}

class ViewController: UIViewController {

    @IBOutlet var fieldView: CNFieldView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationSpeedSlider: UISlider!

    @IBOutlet weak var startMenuButton: CNButton!
    @IBOutlet weak var pauseMenuButton: CNButton!
    @IBOutlet weak var optionsMenuButton: CNButton!
    @IBOutlet weak var editMenuButton: CNButton!
    @IBOutlet weak var loadMenuButton: CNButton!
    @IBOutlet weak var likeMenuButton: CNButton!
    
    @IBOutlet weak var tableViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var startMenuButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsMenuButtonRightConstraint: NSLayoutConstraint!
    
    var currentIndex = 0
    var duration = 0.001
    var runState = CNRunState.Stopped
    
    var buttons: [CNButton] = []
    
    var tableViewDataSource: CNProgramTableViewDataSource!

    var hideControls: Bool = false {
        didSet {
            if hideControls {
                if hideControls != oldValue {
                    UIView.animateWithDuration(0.3,
                        animations: {
                            self.tableView.frame.origin.x -= self.tableView.frame.width + 20.0 + 10.0
                            self.buttons.forEach { button in
                                button.frame.origin.x += button.frame.size.width * 2.0
                            }
                        },
                        completion: { completed in
                            self.tableViewLeftConstraint.constant = self.tableView.frame.width + 20.0 + 10.0
                            self.startMenuButtonRightConstraint.constant = -12.0 - self.startMenuButton.bounds.width * 2.0
                            self.optionsMenuButtonRightConstraint.constant = -12.0 - self.optionsMenuButton.bounds.width * 2.0
                            self.view.setNeedsLayout()
                        }
                    )
                }
            } else {
                if hideControls != oldValue {
                    UIView.animateWithDuration(0.3,
                        animations: {
                            self.tableView.frame.origin.x += self.tableView.frame.width
                            self.buttons.forEach { button in
                                button.frame.origin.x -= button.frame.size.width * 2.0
                            }
                        },
                        completion: { completed in
                            self.tableViewLeftConstraint.constant = 20.0
                            self.startMenuButtonRightConstraint.constant = -12.0
                            self.optionsMenuButtonRightConstraint.constant = -12.0
                            self.view.setNeedsLayout()
                        }
                    )
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pauseMenuButton.setupButtonImage(UIImage(named: "pause"))

        buttons = [
            startMenuButton,
            pauseMenuButton,
            optionsMenuButton,
            editMenuButton,
            loadMenuButton,
            likeMenuButton
        ]
        
        optionsMenuButton.setupButtonImage(UIImage(named: "options"))
        optionsMenuButton.setupButtonColors(
            backColor: UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1.0),
            borderColor: UIColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
        )

        editMenuButton.setupButtonImage(UIImage(named: "edit"))
        editMenuButton.setupButtonColors(
            backColor: UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0),
            borderColor: UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1.0)
        )

        loadMenuButton.setupButtonImage(UIImage(named: "load"))
        loadMenuButton.setupButtonColors(
            backColor: UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0),
            borderColor: UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1.0)
        )

        likeMenuButton.setupButtonImage(UIImage(named: "like"))
        likeMenuButton.setupButtonColors(
            backColor: UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0),
            borderColor: UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)
        )
        
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

        let program = CNProgram(statements: [
            CNStatementPrint(
                parameters: [makeExprFromValue(CNValue.string(value: "Started"))]
            ),
            CNStatementVar(variableName: "step", parameters: [makeExprFromValue(CNValue.int(value: 1))]),
            CNStatementVar(variableName: "sides", parameters: [makeExprFromValue(CNValue.int(value: 10))]),
            CNStatementVar(variableName: "length", parameters: [CNExpression(source: [
                CNExpressionParseElement.Value(value: CNValue.double(value: 400.0)),
                CNExpressionParseElement.Div,
                CNExpressionParseElement.Variable(variableName: "sides")
            ])]),
            CNStatementColor(parameters: [makeExprFromValue(CNValue.color(value: UIColor.orangeColor()))]),
            CNStatementVar(variableName: "angle", parameters: [CNExpression(source: [
                CNExpressionParseElement.Value(value: CNValue.double(value: 360.0)),
                CNExpressionParseElement.Div,
                CNExpressionParseElement.Variable(variableName: "sides"),
            ])]),
            CNStatementRepeat(
                parameters: [makeExprFromValue(CNValue.int(value: 20))],
                statements: [
                    CNStatementPrint(
                        parameters: [CNExpression(source: [
                            CNExpressionParseElement.Variable(variableName: "step")
                        ])]
                    ),
                    CNStatementWidth(
                        parameters: [CNExpression(source: [
                            CNExpressionParseElement.Variable(variableName: "step"),
                            CNExpressionParseElement.Div,
                            CNExpressionParseElement.Value(value: CNValue.double(value: 5.0))
                        ])]
                    ),
                    CNStatementVar(
                        variableName: "step", parameters: [CNExpression(source: [
                            CNExpressionParseElement.Variable(variableName: "step"),
                            CNExpressionParseElement.Add,
                            CNExpressionParseElement.Value(value: CNValue.int(value: 1))
                        ])]
                    ),
                    CNStatementRepeat(
                        parameters: [CNExpression(source: [
                            CNExpressionParseElement.Variable(variableName: "sides")
                        ])],
                        statements: [
                            CNStatementForward(parameters: [CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "length")
                            ])]),
                            CNStatementRotate(parameters: [CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "angle")
                            ])])
                        ]
                    ),
                    CNStatementRotate(parameters: [makeExprFromValue(CNValue.double(value: 18.0))])
                ]
            ),
            CNStatementPrint(
                parameters: [makeExprFromValue(CNValue.string(value: "Finished"))]
            )
        ])

        CNEnviroment.defaultEnviroment.currentProgram = program

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
        tableView.delegate = tableViewDataSource
        tableView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        tableView.layer.shadowRadius = 3.0
        tableView.layer.shadowColor = UIColor.blackColor().CGColor
        tableView.layer.shadowOpacity = 0.5
        tableView.clipsToBounds = false
        tableView.layer.masksToBounds = false
    }

    @IBAction func startMenuButtonTouchUpInside(sender: AnyObject) {
        if runState == .Executing {
            runState = .Stopped
            updateButtons()
        } else {
            runState = .Executing
            updateButtons()
            do {
                let program = CNEnviroment.defaultEnviroment.currentProgram
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

    @IBAction func pauseMenuButtonTouchUpInside(sender: AnyObject) {
        if runState == .Executing {
            runState = .Paused
        } else {
            runState = .Executing
            visualizeStep()
        }
        updateButtons()
    }
    
    @IBAction func loadMenuButtonTouchUpInside(sender: AnyObject) {
        let data = CNEnviroment.defaultEnviroment.currentProgram.store()
        print(data)
    }
    
    @IBAction func animationSurationSliderValueChanged(sender: AnyObject) {
        duration = Double(animationSpeedSlider.value) / 1000.0
    }
    
    @IBAction func fieldViewTap(sender: AnyObject) {
        hideControls = !hideControls
    }
    
    func updateButtons() {
        startMenuButton.setupButtonImage(UIImage(named: runState == CNRunState.Stopped ? "start" : "stop"))

        pauseMenuButton.enabled = runState == .Executing || runState == .Paused

        if pauseMenuButton.enabled {
            pauseMenuButton.setupButtonColors(
                backColor: UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1.0),
                borderColor: UIColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
            )
        } else {
            pauseMenuButton.setupButtonColors(
                backColor: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),
                borderColor: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            )
        }

        if runState == .Stopped {
            startMenuButton.setupButtonColors(
                backColor: UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0),
                borderColor: UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1.0)
            )
        } else {
            startMenuButton.setupButtonColors(
                backColor: UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0),
                borderColor: UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)
            )
        }

        animationSpeedSlider.enabled = runState != .Executing
        
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
        let program = CNEnviroment.defaultEnviroment.currentProgram
        if currentIndex < program.executionHistory.history.count {
            if runState == .Executing {
                fieldView.makeSnapshot()
                var shouldBreak = true
                var rect = CGRectZero
                repeat {
                    shouldBreak = true
                    let item = program.executionHistory.history[currentIndex]
                    if let block = item.block {
                        if let cellRow = tableViewDataSource.indexOfBlock(block) {
                            tableView.selectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 0), animated: true, scrollPosition: .Middle)
                        }
                    }
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
                    case let .Print(value):
                        print(value)
                        currentIndex++
                        self.visualizeStep()
                    case .TailState, .Color, .Width, .Scale, .Step, .StepIn, .StepOut:
                        currentIndex++
                        shouldBreak = false
                        break
                    }
                    
                } while !shouldBreak && (currentIndex < program.executionHistory.history.count)
            }
        }

        if currentIndex >= program.executionHistory.history.count {
            fieldView.makeSnapshot(true)
            runState = .Stopped
            updateButtons()
        }
    }

}

