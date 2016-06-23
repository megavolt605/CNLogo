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

class ViewController: UIViewController, CNFieldViewDelegate {

    @IBOutlet var fieldView: CNFieldView!
    @IBOutlet weak var programTableView: UITableView!

    @IBOutlet weak var startMenuButton: CNButton!
    @IBOutlet weak var pauseMenuButton: CNButton!
    @IBOutlet weak var optionsMenuButton: CNButton!
    @IBOutlet weak var editMenuButton: CNButton!
    @IBOutlet weak var loadMenuButton: CNButton!
    @IBOutlet weak var likeMenuButton: CNButton!
    
    @IBOutlet weak var tableViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var startMenuButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsMenuButtonRightConstraint: NSLayoutConstraint!
    
    var buttons: [CNButton] = []
    
    var tableViewDataSource: CNProgramTableViewDataSource!
    var options = CNOptions()

    var hideControls: Bool = false {
        didSet {
            if hideControls {
                if hideControls != oldValue {
                    UIView.animateWithDuration(0.3,
                        animations: {
                            self.programTableView.frame.origin.x -= self.programTableView.frame.width + 20.0 + 10.0
                            self.buttons.forEach { button in
                                button.frame.origin.x += button.frame.size.width * 2.0
                            }
                        },
                        completion: { completed in
                            self.tableViewLeftConstraint.constant = self.programTableView.frame.width + 20.0 + 10.0
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
                            self.programTableView.frame.origin.x += self.programTableView.frame.width
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

        navigationController?.navigationBarHidden = true
        
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
        
        fieldView.opaque = false
        fieldView.backgroundColor = UIColor.clearColor()
        fieldView.delegate = self
        
        updateButtons()

        func makeExprFromValue(value: CNLCValue) -> CNLCExpression {
            return CNLCExpression(source: [CNLCExpressionParseElement.Value(value: value)])
        }
        
        func makeParamFromValue(value: CNLCValue) -> CNLCParameter {
            return CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.Value(value: value)]))
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

        
        let program = CNLCProgram(
            programName: "Example 2",
            statements: [
                CNLCStatementPrint(
                    executableParameters: [CNLCParameter(value: CNLCValue.String(value: "Started"))]
                ),
                
                CNLCStatementFunction(
                    funcName: "drawSquare",
                    formalParameters: [CNLCVariable(variableName: "sideLength", variableValue: CNLCValue.Double(value: 0.0))],
                    statements: [
                        CNLCStatementRepeat(
                            executableParameters: [CNLCParameter(value: CNLCValue.Int(value: 4))],
                            statements: [
                                CNLCStatementForward(executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                    CNLCExpressionParseElement.Variable(variableName: "sideLength")
                                ]))]),
                                CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                    CNLCExpressionParseElement.Value(value: CNLCValue.Double(value: 90.0))
                                ]))])
                            ]
                        )
                    ]
                ),
                
                CNLCStatementVar(variableName: "step", executableParameters: [CNLCParameter(value: CNLCValue.Int(value: 1))]),
                CNLCStatementColor(executableParameters: [CNLCParameter(value: CNLCValue.Color(value: UIColor.orangeColor()))]),
                CNLCStatementRepeat(
                    executableParameters: [CNLCParameter(value: CNLCValue.Int(value: 20))],
                    statements: [
                        CNLCStatementPrint(
                            executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                CNLCExpressionParseElement.Variable(variableName: "step")
                                ]))]
                        ),
                        CNLCStatementWidth(
                            executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                CNLCExpressionParseElement.Variable(variableName: "step"),
                                CNLCExpressionParseElement.Div,
                                CNLCExpressionParseElement.Value(value: CNLCValue.Double(value: 10.0))
                                ]))]
                        ),
                        CNLCStatementVar(
                            variableName: "step", executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                CNLCExpressionParseElement.Variable(variableName: "step"),
                                CNLCExpressionParseElement.Add,
                                CNLCExpressionParseElement.Value(value: CNLCValue.Int(value: 1))
                                ]))]
                        ),
                        CNLCStatementCall(funcName: "drawSquare", executableParameters: [CNLCVariable(variableName: "sideLength", variableValue: CNLCValue.Double(value: 100.0))]),
                        CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCValue.Double(value: 18.0))])
                    ]
                ),
                CNLCStatementPrint(
                    executableParameters: [CNLCParameter(value: CNLCValue.String(value: "Finished"))]
                )
            ]
        )
        /*
        let program = CNLCProgram(
            programName: "Example 3",
            statements: [
                CNLCStatementPrint(
                    executableParameters: [CNLCParameter(value: .String(value: "Started"))]
                ),
                
                CNLCStatementFunction(
                    funcName: "spiral",
                    formalParameters: [
                        CNLCVariable(variableName: "w", variableValue: .Int(value: 0)),
                        CNLCVariable(variableName: "a", variableValue: .Int(value: 0)),
                        CNLCVariable(variableName: "x", variableValue: .Double(value: 0.0)),
                        CNLCVariable(variableName: "c", variableValue: .Int(value: 0)),
                        CNLCVariable(variableName: "ww", variableValue: .Double(value: 0.0))
                    ],
                    statements: [
                        CNLCStatementIf(
                            executableParameters: [ CNLCParameter(value: CNLCExpression(source: [
                                CNLCExpressionParseElement.Variable(variableName: "c"),
                                CNLCExpressionParseElement.IsNotEqual,
                                CNLCExpressionParseElement.Value(value: .Int(value: 0))
                            ]))],
                            statements: [
                                CNLCStatementWidth(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.Variable(variableName: "ww")]))]),
                                // TODO: parametred color (color [255-w*2, 0, w*2])
                                CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                    CNLCExpressionParseElement.Value(value: .Double(value: 0.0)),
                                    CNLCExpressionParseElement.Sub,
                                    CNLCExpressionParseElement.Variable(variableName: "x")
                                ]))]),
                                CNLCStatementForward(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.Variable(variableName: "w")]))]),
                                CNLCStatementTailUp(),
                                CNLCStatementBackward(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.Variable(variableName: "w")]))]),
                                CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.Variable(variableName: "x")]))]),
                                CNLCStatementForward(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.Variable(variableName: "w")]))]),
                                CNLCStatementTailDown(),
                                CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.Variable(variableName: "a")]))]),
                                CNLCStatementCall(funcName: "spiral", executableParameters: [
                                    CNLCVariable(
                                        variableName: "w",
                                        variableValue: CNLCExpression(source: [
                                            CNLCExpressionParseElement.Variable(variableName: "w"),
                                            CNLCExpressionParseElement.Add,
                                            CNLCExpressionParseElement.Value(value: .Int(value: 1))
                                        ])
                                    ),
                                    CNLCVariable(variableName: "a", variableValue: CNLCExpression(source: [CNLCExpressionParseElement.Variable(variableName: "a")])),
                                    CNLCVariable(
                                        variableName: "x",
                                        variableValue: CNLCExpression(source: [
                                            CNLCExpressionParseElement.Variable(variableName: "x"),
                                            CNLCExpressionParseElement.Add,
                                            CNLCExpressionParseElement.Value(value: .Double(value: 0.7))
                                        ])
                                    ),
                                    CNLCVariable(
                                        variableName: "c",
                                        variableValue: CNLCExpression(source: [
                                            CNLCExpressionParseElement.Variable(variableName: "c"),
                                            CNLCExpressionParseElement.Sub,
                                            CNLCExpressionParseElement.Value(value: .Int(value: 1))
                                        ])
                                    ),
                                    CNLCVariable(
                                        variableName: "ww",
                                        variableValue: CNLCExpression(source: [
                                            CNLCExpressionParseElement.Variable(variableName: "ww"),
                                            CNLCExpressionParseElement.Add,
                                            CNLCExpressionParseElement.Value(value: .Double(value: 0.1))
                                        ])
                                    ),
                                    
                                ])
                            ]
                        )
                    ]
                ),
                
                CNLCStatementCall(funcName: "spiral", executableParameters: [
                    CNLCVariable(variableName: "w", variableValue: .Int(value: 1)),
                    CNLCVariable(variableName: "a", variableValue: .Int(value: 30)),
                    CNLCVariable(variableName: "x", variableValue: .Double(value: 10.0)),
                    CNLCVariable(variableName: "c", variableValue: .Int(value: 90)),
                    CNLCVariable(variableName: "ww", variableValue: .Double(value: 1.0))
                ]),
                CNLCStatementPrint(
                    executableParameters: [CNLCParameter(value: .String(value: "Finished"))]
                )
            ]
        )
        */
        CNLCEnviroment.defaultEnviroment.currentProgram = program

        switch program.prepare() {
        case let .Error(block, error): print("Prepare ERROR: \(error.description) in block: \(block)")
        default: break
        }

        tableViewDataSource = CNProgramTableViewDataSource(program: program)
        programTableView.dataSource = tableViewDataSource
        programTableView.delegate = tableViewDataSource
        programTableView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        programTableView.layer.shadowRadius = 3.0
        programTableView.layer.shadowColor = UIColor.blackColor().CGColor
        programTableView.layer.shadowOpacity = 0.5
        programTableView.clipsToBounds = false
        programTableView.layer.masksToBounds = false
        programTableView.reloadData()
    }

    @IBAction func startMenuButtonTouchUpInside(sender: AnyObject) {
        if fieldView.runState == .Executing {
            fieldView.runState = .Stopped
            updateButtons()
        } else {
            fieldView.runState = .Executing
            updateButtons()
            switch fieldView.execute(options) {
            case let .Error(block, error): print("Execute ERROR: \(error.description) in block \(block)")
            default: break
            }
        }
    }

    @IBAction func pauseMenuButtonTouchUpInside(sender: AnyObject) {
        if fieldView.runState == .Executing {
            fieldView.runState = .Paused
        } else {
            fieldView.runState = .Executing
            fieldView.visualizeStep(options)
        }
        updateButtons()
    }
    
    @IBAction func loadMenuButtonTouchUpInside(sender: AnyObject) {
        if let data = CNLCEnviroment.defaultEnviroment.currentProgram?.store() {
            print(data)
        }
    }
    
    @IBAction func fieldViewTap(sender: AnyObject) {
        hideControls = !hideControls
    }
    
    func updateButtons() {
        startMenuButton.setupButtonImage(UIImage(named: fieldView.runState == CNRunState.Stopped ? "start" : "stop"))

        pauseMenuButton.enabled = fieldView.runState == .Executing || fieldView.runState == .Paused

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

        if fieldView.runState == .Stopped {
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

    }
    
    // CNFieldViewDelegate protocol
    func willExecuteHistoryItem(item: CNLCExecutionHistoryItem) {
        if options.shouldAnimate {
            if let block = item.block {
                if let cellRow = tableViewDataSource.indexOfBlock(block) {
                    programTableView.selectRowAtIndexPath(NSIndexPath(forRow: cellRow, inSection: 0), animated: true, scrollPosition: .Middle)
                }
            }
        }
    }
    
    func didFinishExecution() {
        updateButtons()
    }
    
}

