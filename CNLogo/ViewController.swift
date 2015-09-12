//
//  ViewController.swift
//  CNLogo
//
//  Created by Igor Smirnov on 07/09/15.
//  Copyright (c) 2015 Complex Numbers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CNPlayerDelegate {

    @IBOutlet var fieldView: CNFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        func makeExprFromValue(value: CNValue) -> CNExpression {
            return CNExpression(source: [CNExpressionParseElement.Value(value: value)])
        }
        
        
        program.statements = [
            CNStatementRepeat(
                parameters: [makeExprFromValue(CNValue.int(value: 10))],
                statements: [
                    CNStatementPrint(parameters: [makeExprFromValue(CNValue.string(value: "!!!"))]),
                    CNStatementForward(parameters: [CNExpression(source: [
                        CNExpressionParseElement.BracketOpen,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 2.0)),
                        CNExpressionParseElement.Add,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 8.0)),
                        CNExpressionParseElement.BracketClose,
                        CNExpressionParseElement.Mul,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 3.0))
                    ])]),
                    CNStatementRotate(parameters: [CNExpression(source: [
                        CNExpressionParseElement.Value(value: CNValue.double(value: 360.0)),
                        CNExpressionParseElement.Div,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 20.0))
                        ])]),
                    CNStatementTailUp(),
                    CNStatementForward(parameters: [CNExpression(source: [
                        CNExpressionParseElement.Value(value: CNValue.double(value: 10.0)),
                        CNExpressionParseElement.Add,
                        CNExpressionParseElement.Value(value: CNValue.double(value: 20.0))
                        ])]),
                    CNStatementRotate(parameters: [
                        CNExpression(source: [
                            CNExpressionParseElement.Value(value: CNValue.double(value: 360.0)),
                            CNExpressionParseElement.Div,
                            CNExpressionParseElement.Value(value: CNValue.double(value: 20.0))
                        ])
                    ]),
                    CNStatementTailDown()
                ] as [CNStatement]
            )
        ]
        program.playerDelegate = self
        program.player.position = view.center
        try! program.prepare()
        try! program.execute()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var savedPosition: CGPoint!
    
    func player(player: CNPlayer, willMoveFromPosition position: CGPoint) {
        savedPosition = position
    }
    
    func player(player: CNPlayer, didMoveToPosition position: CGPoint) {
        fieldView.elements.append(
            CNFieldElement(fromPoint: savedPosition, toPoint: position, visible: player.tailDown, lineWidth: player.width, lineColor: player.color)
        )

    }
    
    func player(player: CNPlayer, willRotateFromAngle angle: CGFloat) {
        
    }
    
    func player(player: CNPlayer, didRotateToAngle angle: CGFloat) {
        
    }
    
    func player(player: CNPlayer, didTailChangeTo change: Bool) {
        
    }
    
    func player(player: CNPlayer, willSetColor color: UIColor) {
        
    }
    
    func player(player: CNPlayer, didSetColor color: UIColor) {
        
    }

    func player(player: CNPlayer, willSetWidth width: CGFloat) {
        
    }
    
    func player(player: CNPlayer, didSetWidth width: CGFloat) {
        
    }
    
}

