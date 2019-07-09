//
//  File.swift
//  
//
//  Created by Joel Meng on 7/4/19.
//

import UIKit

open class ReflexTableViewCell<T>: UITableViewCell {
    
    /// This function will be called when cell is tapped
    public var didTap: (() -> Void)?
    
    open override func prepareForReuse() {
        didTap = nil
    }
    
    open func config(_ item: T) {
        // Leave this function to be overriden by subclass.
        fatalError("Must to override config method")
    }
}
