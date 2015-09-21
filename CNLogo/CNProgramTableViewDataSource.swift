//
//  CNProgramTableViewDataSource.swift
//  CNLogo
//
//  Created by Igor Smirnov on 21/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

class CNProgramTableViewDataSource: NSObject, UITableViewDataSource {

    private var program: CNProgram
    private var executableList: [(block: CNBlock, level: Int, startIndex: Int?)] = []
    
    // UITableViewDataSource protocol
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return executableList.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let item = executableList[indexPath.row]
        let shift = (0..<item.level).reduce("") { (a: String, b: Int) in return a + ">" }
        cell.textLabel?.font = UIFont.systemFontOfSize(8.0)
        cell.textLabel?.text = shift + (item.startIndex == nil ? "" : "End of ") + item.block.description
        return cell
    }

    func scanBlock(block: CNBlock, level: Int) {
        block.statements.forEach {
            let startIndex = executableList.count
            executableList.append((block: $0, level: level, startIndex: nil))
            if $0.statements.count > 0 {
                scanBlock($0, level: level + 1)
                executableList.append((block: $0, level: level + 1, startIndex: startIndex))
            }
        }
    }
    
    init(program: CNProgram) {
        self.program = program
        super.init()
        scanBlock(program, level: 0)
    }
    
}
