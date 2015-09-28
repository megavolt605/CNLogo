//
//  CNLogoCoreTests.swift
//  CNLogoCoreTests
//
//  Created by Igor Smirnov on 28/09/15.
//  Copyright © 2015 Complex Number. All rights reserved.
//

import XCTest
@testable import CNLogoCore

class CNExpressionTests: XCTestCase {
    
    /*
    override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    }
    */
    
    func testSimple() {
        // This is an example of a functional test case.
        
        let expression = CNExpression(source: [
            CNExpressionParseElement.Value(value: CNValue.int(value: 2)),
            CNExpressionParseElement.Add,
            CNExpressionParseElement.Value(value: CNValue.int(value: 2))
            ])
        
        try! expression.prepare()
        
        switch try! expression.execute() {
        case let .int(value): XCTAssert(value == 4, "2+2 != 4")
        default: XCTAssert(false, "Not int result")
        }
        
    }
    
    func testComplex() {
        // This is an example of a functional test case.
        
        let expression = CNExpression(source: [
            CNExpressionParseElement.BracketOpen,
            CNExpressionParseElement.Value(value: CNValue.int(value: 3)),
            CNExpressionParseElement.Power,
            CNExpressionParseElement.Value(value: CNValue.int(value: 2)),
            CNExpressionParseElement.Add,
            CNExpressionParseElement.Value(value: CNValue.int(value: 4)),
            CNExpressionParseElement.Power,
            CNExpressionParseElement.Value(value: CNValue.int(value: 2)),
            CNExpressionParseElement.BracketClose,
            CNExpressionParseElement.Power,
            CNExpressionParseElement.Value(value: CNValue.double(value: 0.5))
            ])
        
        try! expression.prepare()
        
        switch try! expression.execute() {
        case let .double(value): XCTAssert(value == 5.0, "Should be 5.0")
        default: XCTAssert(false, "Not double result")
        }
        
    }
    
    /*
    func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
    // Put the code you want to measure the time of here.
    }
    }
    */
    
}

