//
//  CNProgramTableViewDataSource.swift
//  CNLogo
//
//  Created by Igor Smirnov on 21/09/15.
//  Copyright © 2015 Complex Numbers. All rights reserved.
//

import CNLogoCore
import UIKit

typealias CNProgramTableViewItem = (block: CNLCBlock, level: Int, startIndex: Int?)

class CNProgramTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    fileprivate var program: CNLCProgram
    fileprivate var tableList: [CNProgramTableViewItem] = []
    
    func indexOfBlock(_ block: CNLCBlock) -> Int? {
        return tableList.index { item in
            return item.block === block
        }
    }
    
    // UITableViewDataSource protocol
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CNProgramTableViewCell
        cell.setup(tableList[(indexPath as NSIndexPath).row], height: CNProgramTableViewCell.defaultHeight)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CNProgramTableViewCell.defaultHeight
    }
    
    func scanBlock(_ block: CNLCBlock, level: Int) {
        block.statements.forEach {
            let startIndex = tableList.count
            tableList.append((block: $0, level: level, startIndex: nil))
            if $0.statements.count > 0 {
                scanBlock($0, level: level + 1)
                tableList.append((block: $0, level: level + 1, startIndex: startIndex))
            }
        }
    }
    
    init(program: CNLCProgram) {
        self.program = program
        super.init()
        scanBlock(program, level: 0)
    }
    
}
