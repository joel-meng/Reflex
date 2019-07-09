//
//  SimpleTable.swift
//  PlayWithReflex
//
//  Created by Joel Meng on 7/3/19.
//  Copyright © 2019 Joel Meng. All rights reserved.
//

import Foundation
import UIKit
import DeepDiff


public func customCellDataUpdater
    <T: DiffAware, C: ReflexTableViewCell<T>>(for tableView: UITableView,
                                              bindAction: @escaping (T, C) -> Void) -> (_ items: [T]) -> Void {
    // Register custom cell for item type. It register nib for that cell using default item's type name
    tableView.registerDefaultCell(for: T.self)
    
    // Bind tableview with data source and delegate
    let tableDataSourceAndDelegate = SingleSectionTableDelegate<T>()
    tableView.dataSource = tableDataSourceAndDelegate
    tableView.delegate = tableDataSourceAndDelegate
    
    return { [weak tableView] items in
        // Closure to configure table cell's action
        tableDataSourceAndDelegate.cell = { indexPath, tableView in
            // Dequeue default cell for item particular type by index path, and convert to cell type for item
            let cell: C = tableView.dequeueDefaultReusableCell(forIndexPath: indexPath)
            // Get item
            let item = items[indexPath.row]
            // Configure cell for item
            cell.config(item)
            // Bind action (didTap) to cell
            bindAction(item, cell)
            return cell
        }
        // Reload table view with default animation
        reload(tableView: tableView, with: items, in: tableDataSourceAndDelegate)
    }
}

/// Will reload table view with items. This function will figure out the difference between items and
/// orignal items, and animat the update.
/// - Parameter tableView: To which to reload the items.
/// - Parameter items: Items to be displayed on the table view.
/// - Parameter dataSource: TableView's internal data source and delegate object.
fileprivate func reload<T: DiffAware>(tableView: UITableView?, with items: [T], in dataSource: SingleSectionTableDelegate<T>) {
    // Populate difference
    let difference = diff(old: dataSource.items, new: items)
    
    // Reload tableview with default animation
    tableView?.reload(changes: difference, section: 0, updateData: {
        // Before inserting/deleting/moving/updating row, update data source contents of items
        dataSource.items = items
    }, completion: nil)
}

// MARK: - Single Section Table DataSource & Delegate

class SingleSectionTableDelegate<T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    /// Closure to configure an paticular tableview cell
    var cell: ((IndexPath, UITableView) -> UITableViewCell) = { _ , _  in
        return UITableViewCell(style: .default, reuseIdentifier: "")
    }
    
    /// Section Header
    var header: String?
    
    /// Tableview's content of items
    var items: [T] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(indexPath, tableView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath) as? ReflexTableViewCell<T>
        selectedCell?.didTap?()
    }
}
