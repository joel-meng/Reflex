//
//  Reader.swift
//  Reflex
//
//  Created by Joel Meng on 7/3/19.
//

import Foundation

struct Reader<FromType, ToType> {
    
    var f: (FromType) -> ToType
    
    init(_ f: @escaping (FromType) -> ToType) {
        self.f = f
    }
    
    func apply(from: FromType) -> ToType {
        return f(from)
    }
    
    func map<AnotherToType>(f: @escaping (ToType) -> AnotherToType) -> Reader<FromType, AnotherToType> {
        return Reader<FromType, AnotherToType> { from in
            f(self.f(from))
        }
    }
    
    func flatMap<AnotherToType>(f: @escaping (ToType) -> Reader<FromType, AnotherToType>) -> Reader<FromType, AnotherToType> {
        return Reader<FromType, AnotherToType> { from in
            f(self.f(from)).f(from)
        }
    }
}
