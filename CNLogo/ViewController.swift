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

        func makeExprFromValue(value: CNValue) -> CNExpression {
            return CNExpression(source: [CNExpressionParseElement.Value(value: value)])
        }
        
        func makeParamFromValue(value: CNValue) -> CNParameter {
            return CNParameter(value: CNExpression(source: [CNExpressionParseElement.Value(value: value)]))
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

        /*
        let program = CNProgram(
            programName: "Example 1",
            statements: [
                CNStatementPrint(
                    executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                        CNExpressionParseElement.Function(functionName: "SIN", functionParameters: [CNExpression(source: [
                            CNExpressionParseElement.Value(value: CNValue.double(value: 0.2))
                        ])])
                    ]))]
                ),
                CNStatementPrint(
                    executableParameters: [makeParamFromValue(CNValue.string(value: "Started"))]
                ),
                CNStatementVar(variableName: "step", executableParameters: [makeParamFromValue(CNValue.int(value: 1))]),
                CNStatementVar(variableName: "sides", executableParameters: [makeParamFromValue(CNValue.int(value: 10))]),
                CNStatementVar(variableName: "length", executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                    CNExpressionParseElement.Value(value: CNValue.double(value: 400.0)),
                    CNExpressionParseElement.Div,
                    CNExpressionParseElement.Variable(variableName: "sides")
                ]))]),
                CNStatementColor(executableParameters: [makeParamFromValue(CNValue.color(value: UIColor.orangeColor()))]),
                CNStatementVar(variableName: "angle", executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                    CNExpressionParseElement.Value(value: CNValue.double(value: 360.0)),
                    CNExpressionParseElement.Div,
                    CNExpressionParseElement.Variable(variableName: "sides"),
                ]))]),
                CNStatementRepeat(
                    executableParameters: [makeParamFromValue(CNValue.int(value: 20))],
                    statements: [
                        CNStatementPrint(
                            executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "step")
                            ]))]
                        ),
                        CNStatementWidth(
                            executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "step"),
                                CNExpressionParseElement.Div,
                                CNExpressionParseElement.Value(value: CNValue.double(value: 5.0))
                            ]))]
                        ),
                        CNStatementVar(
                            variableName: "step", executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "step"),
                                CNExpressionParseElement.Add,
                                CNExpressionParseElement.Value(value: CNValue.int(value: 1))
                            ]))]
                        ),
                        CNStatementRepeat(
                            executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "sides")
                            ]))],
                            statements: [
                                CNStatementForward(executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                                    CNExpressionParseElement.Variable(variableName: "length")
                                ]))]),
                                CNStatementRotate(executableParameters: [CNExecutableParameter(value: CNExpression(source: [
                                    CNExpressionParseElement.Variable(variableName: "angle")
                                ]))])
                            ]
                        ),
                        CNStatementRotate(executableParameters: [makeParamFromValue(CNValue.double(value: 18.0))])
                    ]
                ),
                CNStatementPrint(
                    executableParameters: [makeParamFromValue(CNValue.string(value: "Finished"))]
                )
            ]
        )*/

        /*
        let program = CNProgram(
            programName: "Example 2",
            statements: [
                CNStatementPrint(
                    executableParameters: [CNParameter(value: CNValue.string(value: "Started"))]
                ),
                
                CNStatementFunction(
                    funcName: "drawSquare",
                    formalParameters: [CNVariable(variableName: "sideLength", variableValue: CNValue.double(value: 0.0))],
                    statements: [
                        CNStatementRepeat(
                            executableParameters: [CNParameter(value: CNValue.int(value: 4))],
                            statements: [
                                CNStatementForward(executableParameters: [CNParameter(value: CNExpression(source: [
                                    CNExpressionParseElement.Variable(variableName: "sideLength")
                                ]))]),
                                CNStatementRotate(executableParameters: [CNParameter(value: CNExpression(source: [
                                    CNExpressionParseElement.Value(value: CNValue.double(value: 90.0))
                                ]))])
                            ]
                        )
                    ]
                ),
                
                CNStatementVar(variableName: "step", executableParameters: [CNParameter(value: CNValue.int(value: 1))]),
                CNStatementColor(executableParameters: [CNParameter(value: CNValue.color(value: UIColor.orangeColor()))]),
                CNStatementRepeat(
                    executableParameters: [CNParameter(value: CNValue.int(value: 20))],
                    statements: [
                        CNStatementPrint(
                            executableParameters: [CNParameter(value: CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "step")
                                ]))]
                        ),
                        CNStatementWidth(
                            executableParameters: [CNParameter(value: CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "step"),
                                CNExpressionParseElement.Div,
                                CNExpressionParseElement.Value(value: CNValue.double(value: 10.0))
                                ]))]
                        ),
                        CNStatementVar(
                            variableName: "step", executableParameters: [CNParameter(value: CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "step"),
                                CNExpressionParseElement.Add,
                                CNExpressionParseElement.Value(value: CNValue.int(value: 1))
                                ]))]
                        ),
                        CNStatementCall(funcName: "drawSquare", executableParameters: [CNVariable(variableName: "sideLength", variableValue: CNValue.double(value: 100.0))]),
                        CNStatementRotate(executableParameters: [CNParameter(value: CNValue.double(value: 18.0))])
                    ]
                ),
                CNStatementPrint(
                    executableParameters: [CNParameter(value: CNValue.string(value: "Finished"))]
                )
            ]
        )*/
        
        let program = CNProgram(
            programName: "Example 3",
            statements: [
                CNStatementPrint(
                    executableParameters: [CNParameter(value: .String(value: "Started"))]
                ),
                
                CNStatementFunction(
                    funcName: "spiral",
                    formalParameters: [
                        CNVariable(variableName: "w", variableValue: .Int(value: 0)),
                        CNVariable(variableName: "a", variableValue: .Int(value: 0)),
                        CNVariable(variableName: "x", variableValue: .Double(value: 0.0)),
                        CNVariable(variableName: "c", variableValue: .Int(value: 0)),
                        CNVariable(variableName: "ww", variableValue: .Double(value: 0.0))
                    ],
                    statements: [
                        CNStatementIf(
                            executableParameters: [ CNParameter(value: CNExpression(source: [
                                CNExpressionParseElement.Variable(variableName: "c"),
                                CNExpressionParseElement.IsNotEqual,
                                CNExpressionParseElement.Value(value: .Int(value: 0))
                            ]))],
                            statements: [
                                CNStatementWidth(executableParameters: [CNParameter(value: CNExpression(source: [CNExpressionParseElement.Variable(variableName: "ww")]))]),
                                // TODO: parametred color (color [255-w*2, 0, w*2])
                                CNStatementRotate(executableParameters: [CNParameter(value: CNExpression(source: [
                                    CNExpressionParseElement.Value(value: .Double(value: 0.0)),
                                    CNExpressionParseElement.Sub,
                                    CNExpressionParseElement.Variable(variableName: "x")
                                ]))]),
                                CNStatementForward(executableParameters: [CNParameter(value: CNExpression(source: [CNExpressionParseElement.Variable(variableName: "w")]))]),
                                CNStatementTailUp(),
                                CNStatementBackward(executableParameters: [CNParameter(value: CNExpression(source: [CNExpressionParseElement.Variable(variableName: "w")]))]),
                                CNStatementRotate(executableParameters: [CNParameter(value: CNExpression(source: [CNExpressionParseElement.Variable(variableName: "x")]))]),
                                CNStatementForward(executableParameters: [CNParameter(value: CNExpression(source: [CNExpressionParseElement.Variable(variableName: "w")]))]),
                                CNStatementTailDown(),
                                CNStatementRotate(executableParameters: [CNParameter(value: CNExpression(source: [CNExpressionParseElement.Variable(variableName: "a")]))]),
                                CNStatementCall(funcName: "spiral", executableParameters: [
                                    CNVariable(
                                        variableName: "w",
                                        variableValue: CNExpression(source: [
                                            CNExpressionParseElement.Variable(variableName: "w"),
                                            CNExpressionParseElement.Add,
                                            CNExpressionParseElement.Value(value: .Int(value: 1))
                                        ])
                                    ),
                                    CNVariable(variableName: "a", variableValue: CNExpression(source: [CNExpressionParseElement.Variable(variableName: "a")])),
                                    CNVariable(
                                        variableName: "x",
                                        variableValue: CNExpression(source: [
                                            CNExpressionParseElement.Variable(variableName: "x"),
                                            CNExpressionParseElement.Add,
                                            CNExpressionParseElement.Value(value: .Double(value: 0.7))
                                        ])
                                    ),
                                    CNVariable(
                                        variableName: "c",
                                        variableValue: CNExpression(source: [
                                            CNExpressionParseElement.Variable(variableName: "c"),
                                            CNExpressionParseElement.Sub,
                                            CNExpressionParseElement.Value(value: .Int(value: 1))
                                        ])
                                    ),
                                    CNVariable(
                                        variableName: "ww",
                                        variableValue: CNExpression(source: [
                                            CNExpressionParseElement.Variable(variableName: "ww"),
                                            CNExpressionParseElement.Add,
                                            CNExpressionParseElement.Value(value: .Double(value: 0.1))
                                        ])
                                    ),
                                    
                                ])
                            ]
                        )
                    ]
                ),
                
                CNStatementCall(funcName: "spiral", executableParameters: [
                    CNVariable(variableName: "w", variableValue: .Int(value: 1)),
                    CNVariable(variableName: "a", variableValue: .Int(value: 30)),
                    CNVariable(variableName: "x", variableValue: .Double(value: 10.0)),
                    CNVariable(variableName: "c", variableValue: .Int(value: 90)),
                    CNVariable(variableName: "ww", variableValue: .Double(value: 1.0))
                ]),
                CNStatementPrint(
                    executableParameters: [CNParameter(value: .String(value: "Finished"))]
                )
            ]
        )

        CNEnviroment.defaultEnviroment.currentProgram = program

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
            do {
                try fieldView.execute(options)
            } catch let error as CNError {
                print("Execute ERROR: \(error.description)")
            } catch {
                print("Unknown error")
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
        if let data = CNEnviroment.defaultEnviroment.currentProgram?.store() {
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
    func willExecuteHistoryItem(item: CNExecutionHistoryItem) {
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

