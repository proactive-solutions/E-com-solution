//
//  Mappable.swift
//  ValidationKit
//
//  Created by Pawan Sharma on 10/03/2025.
//

public protocol Mappable {
    func map<T>(_ transform: (_ value: Self) -> T) -> T
}

public extension Mappable {
    func map<T>(_ transform: (_ value: Self) -> T) -> T {
        transform(self)
    }
}
