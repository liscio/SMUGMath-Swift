//
//  Unsafeable.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2015-06-14.
//  Copyright © 2015 Christopher Liscio. All rights reserved.
//

import Foundation

public protocol Unsafeable {
    typealias T
    func withUnsafeBufferPointer<R>(@noescape body: (UnsafeBufferPointer<T>) -> R) -> R
    mutating func withUnsafeMutableBufferPointer<R>(@noescape body: (inout UnsafeMutableBufferPointer<T>) -> R) -> R
}

extension ContiguousArray : Unsafeable {}
extension ArraySlice : Unsafeable {}