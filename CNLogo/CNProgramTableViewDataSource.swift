//
//  CNProgramTableViewDataSource.swift
//  CNLogo
//
//  Created by Igor Smirnov on 21/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import UIKit

typealias CNProgramTableViewItem = (block: CNBlock, level: Int, startIndex: Int?)

class CNProgramTableViewDataSource: NSObject, UITableViewDataSource {

    private var program: CNProgram
    private var tableList: [CNProgramTableViewItem] = []
    
    // UITableViewDataSource protocol
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CNProgramTableViewCell
        cell.setup(tableList[indexPath.row])
        return cell
    }

    func scanBlock(block: CNBlock, level: Int) {
        block.statements.forEach {
            let startIndex = tableList.count
            tableList.append((block: $0, level: level, startIndex: nil))
            if $0.statements.count > 0 {
                scanBlock($0, level: level + 1)
                tableList.append((block: $0, level: level + 1, startIndex: startIndex))
            }
        }
    }
    
    init(program: CNProgram) {
        self.program = program
        super.init()
        scanBlock(program, level: 0)
    }
    
}
