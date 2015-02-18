//
//  Unsafeable.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2/18/15.
//  Copyright (c) 2015 Christopher Liscio. All rights reserved.
//

import Foundation

public protocol Unsafeable : MutableCollectionType {
    func withUnsafeBufferPointer<R>(body: (UnsafeBufferPointer<Self.Generator.Element>) -> R) -> R
    mutating func withUnsafeMutableBufferPointer<R>(body: (inout UnsafeMutableBufferPointer<Self.Generator.Element>) -> R) -> R
}

extension Array : Unsafeable {}
extension Slice : Unsafeable {}