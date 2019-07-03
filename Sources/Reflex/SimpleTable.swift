//
//  SimpleTable.swift
//  Reflex
//
//  Created by Joel Meng on 7/3/19.
//

import Foundation
import UIKit

public func simpleDataUpdater<T>(for tableView: UITableView,
                          configCell: @escaping (T, UITableViewCell) -> Void) -> (_ items: [T]) -> Void {
    let dataSource = SimpleDataSource<T>()
    registerCell(on: tableView, for: T.self)
    tableView.dataSource = dataSource
    
    return { items in
        dataSource.sectionCount = 1
        dataSource.rowCount = { _ in items.count }
        dataSource.cell = { indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: typeString(T.self), for: indexPath)
            configCell(items[indexPath.row], cell)
            return cell
        }
    }
}


class SimpleDataSource<T>: NSObject, UITableViewDataSource {
    
    var sectionCount: Int!
    
    var rowCount: ((Int) -> Int)!
    
    var cell: ((IndexPath, UITableView) -> UITableViewCell)!
    
    var header: String?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(indexPath, tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header
    }
}

fileprivate func registerCell<T>(on tableView: UITableView, for item: T) {
    return tableView.register(cellNib(from: T.self),
                              forCellReuseIdentifier: cellIdentifier(from: T.self) )
}

fileprivate func cellIdentifier<T>(from itemType: T.Type) -> String {
    return "\(typeString(itemType))TableViewCell"
}

fileprivate func cellNib<T>(from itemType: T.Type, bundle: Bundle? = nil) -> UINib {
    return UINib(nibName: typeString(itemType), bundle: bundle)
}

fileprivate func typeString<T>(_ type: T.Type) -> String {
    return String(String(describing: T.self).split(separator: ".").first!)
}
