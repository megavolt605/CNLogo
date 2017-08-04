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
    case stopped, executing, paused
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
                    UIView.animate(withDuration: 0.3,
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
                    UIView.animate(withDuration: 0.3,
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

        navigationController?.isNavigationBarHidden = true
        
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
        
        fieldView.isOpaque = false
        fieldView.backgroundColor = UIColor.clear
        fieldView.delegate = self
        
        updateButtons()

        func makeExprFromValue(_ value: CNLCValue) -> CNLCExpression {
            return CNLCExpression(source: [CNLCExpressionParseElement.Value(value: value)])
        }
        
        func makeParamFromValue(_ value: CNLCValue) -> CNLCParameter {
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

      /*
        let program = CNLCProgram(
            programName: "Example 2",
            statements: [
                CNLCStatementPrint(
                    executableParameters: [CNLCParameter(value: CNLCValue.string(value: "Started"))]
                ),
                
                CNLCStatementFunction(
                    funcName: "drawSquare",
                    formalParameters: [CNLCVariable(variableName: "sideLength", variableValue: CNLCValue.double(value: 0.0))],
                    statements: [
                        CNLCStatementRepeat(
                            executableParameters: [CNLCParameter(value: CNLCValue.int(value: 4))],
                            statements: [
                                CNLCStatementForward(executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                    CNLCExpressionParseElement.variable(variableName: "sideLength")
                                ]))]),
                                CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                    CNLCExpressionParseElement.Value(value: CNLCValue.double(value: 90.0))
                                ]))])
                            ]
                        )
                    ]
                ),
                
                CNLCStatementVar(variableName: "step", executableParameters: [CNLCParameter(value: CNLCValue.int(value: 1))]),
                CNLCStatementColor(executableParameters: [CNLCParameter(value: CNLCValue.color(value: UIColor.orange))]),
                CNLCStatementRepeat(
                    executableParameters: [CNLCParameter(value: CNLCValue.int(value: 20))],
                    statements: [
                        CNLCStatementPrint(
                            executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                CNLCExpressionParseElement.variable(variableName: "step")
                                ]))]
                        ),
                        CNLCStatementWidth(
                            executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                CNLCExpressionParseElement.variable(variableName: "step"),
                                CNLCExpressionParseElement.div,
                                CNLCExpressionParseElement.Value(value: CNLCValue.double(value: 10.0))
                                ]))]
                        ),
                        CNLCStatementVar(
                            variableName: "step", executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                CNLCExpressionParseElement.variable(variableName: "step"),
                                CNLCExpressionParseElement.add,
                                CNLCExpressionParseElement.Value(value: CNLCValue.int(value: 1))
                                ]))]
                        ),
                        CNLCStatementCall(funcName: "drawSquare", executableParameters: [CNLCVariable(variableName: "sideLength", variableValue: CNLCValue.double(value: 100.0))]),
                        CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCValue.double(value: 18.0))])
                    ]
                ),
                CNLCStatementPrint(
                    executableParameters: [CNLCParameter(value: CNLCValue.string(value: "Finished"))]
                )
            ]
        )*/
        
        let program = CNLCProgram(
            programName: "Example 3",
            statements: [
                CNLCStatementPrint(
                    executableParameters: [CNLCParameter(value: CNLCValue.string(value: "Started"))]
                ),
                
                CNLCStatementFunction(
                    funcName: "spiral",
                    formalParameters: [
                        CNLCVariable(variableName: "w", variableValue: CNLCValue.int(value: 0)),
                        CNLCVariable(variableName: "a", variableValue: CNLCValue.int(value: 0)),
                        CNLCVariable(variableName: "x", variableValue: CNLCValue.double(value: 0.0)),
                        CNLCVariable(variableName: "c", variableValue: CNLCValue.int(value: 0)),
                        CNLCVariable(variableName: "ww", variableValue: CNLCValue.double(value: 0.0))
                    ],
                    statements: [
                        CNLCStatementIf(
                            executableParameters: [ CNLCParameter(value: CNLCExpression(source: [
                                CNLCExpressionParseElement.variable(variableName: "c"),
                                CNLCExpressionParseElement.isNotEqual,
                                CNLCExpressionParseElement.Value(value: .int(value: 0))
                            ]))],
                            statements: [
                                CNLCStatementWidth(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.variable(variableName: "ww")]))]),
                                // TODO: parametred color (color [255-w*2, 0, w*2])
                                CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCExpression(source: [
                                    CNLCExpressionParseElement.Value(value: .double(value: 0.0)),
                                    CNLCExpressionParseElement.sub,
                                    CNLCExpressionParseElement.variable(variableName: "x")
                                ]))]),
                                CNLCStatementForward(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.variable(variableName: "w")]))]),
                                CNLCStatementTailUp(),
                                CNLCStatementBackward(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.variable(variableName: "w")]))]),
                                CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.variable(variableName: "x")]))]),
                                CNLCStatementForward(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.variable(variableName: "w")]))]),
                                CNLCStatementTailDown(),
                                CNLCStatementRotate(executableParameters: [CNLCParameter(value: CNLCExpression(source: [CNLCExpressionParseElement.variable(variableName: "a")]))]),
                                CNLCStatementCall(funcName: "spiral", executableParameters: [
                                    CNLCVariable(
                                        variableName: "w",
                                        variableValue: CNLCExpression(source: [
                                            CNLCExpressionParseElement.variable(variableName: "w"),
                                            CNLCExpressionParseElement.add,
                                            CNLCExpressionParseElement.Value(value: .int(value: 1))
                                        ])
                                    ),
                                    CNLCVariable(variableName: "a", variableValue: CNLCExpression(source: [CNLCExpressionParseElement.variable(variableName: "a")])),
                                    CNLCVariable(
                                        variableName: "x",
                                        variableValue: CNLCExpression(source: [
                                            CNLCExpressionParseElement.variable(variableName: "x"),
                                            CNLCExpressionParseElement.add,
                                            CNLCExpressionParseElement.Value(value: .double(value: 0.7))
                                        ])
                                    ),
                                    CNLCVariable(
                                        variableName: "c",
                                        variableValue: CNLCExpression(source: [
                                            CNLCExpressionParseElement.variable(variableName: "c"),
                                            CNLCExpressionParseElement.sub,
                                            CNLCExpressionParseElement.Value(value: .int(value: 1))
                                        ])
                                    ),
                                    CNLCVariable(
                                        variableName: "ww",
                                        variableValue: CNLCExpression(source: [
                                            CNLCExpressionParseElement.variable(variableName: "ww"),
                                            CNLCExpressionParseElement.add,
                                            CNLCExpressionParseElement.Value(value: .double(value: 0.1))
                                        ])
                                    ),
                                    
                                ])
                            ]
                        )
                    ]
                ),
                
                CNLCStatementCall(funcName: "spiral", executableParameters: [
                    CNLCVariable(variableName: "w", variableValue: .int(value: 1)),
                    CNLCVariable(variableName: "a", variableValue: .int(value: 30)),
                    CNLCVariable(variableName: "x", variableValue: .double(value: 10.0)),
                    CNLCVariable(variableName: "c", variableValue: .int(value: 90)),
                    CNLCVariable(variableName: "ww", variableValue: .double(value: 1.0))
                ]),
                CNLCStatementPrint(
                    executableParameters: [CNLCParameter(value: .string(value: "Finished"))]
                )
            ]
        )
        
        CNLCEnviroment.defaultEnviroment.currentProgram = program

        switch program.prepare() {
        case let .error(block, error): print("Prepare ERROR: \(error.description) in block: \(String(describing: block))")
        default: break
        }

        tableViewDataSource = CNProgramTableViewDataSource(program: program)
        programTableView.dataSource = tableViewDataSource
        programTableView.delegate = tableViewDataSource
        programTableView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        programTableView.layer.shadowRadius = 3.0
        programTableView.layer.shadowColor = UIColor.black.cgColor
        programTableView.layer.shadowOpacity = 0.5
        programTableView.clipsToBounds = false
        programTableView.layer.masksToBounds = false
        programTableView.reloadData()
    }

    @IBAction func startMenuButtonTouchUpInside(_ sender: AnyObject) {
        if fieldView.runState == .executing {
            fieldView.runState = .stopped
            updateButtons()
        } else {
            fieldView.runState = .executing
            updateButtons()
            switch fieldView.execute(options) {
            case let .error(block, error): print("Execute ERROR: \(error.description) in block \(String(describing: block))")
            default: break
            }
        }
    }

    @IBAction func pauseMenuButtonTouchUpInside(_ sender: AnyObject) {
        if fieldView.runState == .executing {
            fieldView.runState = .paused
        } else {
            fieldView.runState = .executing
            fieldView.visualizeStep(options)
        }
        updateButtons()
    }
    
    @IBAction func loadMenuButtonTouchUpInside(_ sender: AnyObject) {
        if let data = CNLCEnviroment.defaultEnviroment.currentProgram?.store() {
            print(data)
        }
    }
    
    @IBAction func fieldViewTap(_ sender: AnyObject) {
        hideControls = !hideControls
    }
    
    func updateButtons() {
        startMenuButton.setupButtonImage(UIImage(named: fieldView.runState == CNRunState.stopped ? "start" : "stop"))

        pauseMenuButton.isEnabled = fieldView.runState == .executing || fieldView.runState == .paused

        if pauseMenuButton.isEnabled {
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

        if fieldView.runState == .stopped {
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
    func willExecuteHistoryItem(_ item: CNLCExecutionHistoryItem) {
        if options.shouldAnimate {
            if let block = item.block {
                if let cellRow = tableViewDataSource.indexOfBlock(block) {
                    programTableView.selectRow(at: IndexPath(row: cellRow, section: 0), animated: true, scrollPosition: .middle)
                }
            }
        }
    }
    
    func didFinishExecution() {
        updateButtons()
    }
    
}

