//
//  ComplexVector.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

public struct Complex<T> {
    var real: T
    var imag: T
}

public protocol SplitComplexVectorType {
    typealias ElementType : FloatingPointType
    
    var real: Vector<Self.ElementType> { get }
    var imag: Vector<Self.ElementType> { get }
    
    var count: Int { get }
}

public struct SplitComplexVector<T: FloatingPointType> : SplitComplexVectorType {
    public var real: Vector<T>
    public var imag: Vector<T>
    
    init( real: Vector<T>, imag: Vector<T> ) {
        self.real = real
        self.imag = imag
    }
    
    init( count: Int, repeatedValue: Complex<T> ) {
        self.real = Vector<T>(zeros: count)
        self.imag = Vector<T>(zeros: count)
    }
    
    subscript(i: Int) -> Complex<T> {
        return Complex<T>(real: real[i], imag: imag[i]);
    }
    
    public var count: Int {
        get {
            return real.count
        }
    }
}

extension Complex : CustomStringConvertible {
    public var description: String {
        return "\(self.real)+\(self.imag)i";
    }
}

extension SplitComplexVector : CustomStringConvertible {
    public var description: String {
        let maxElements = 25
        var desc = "["
        for i in 0..<min(self.count, maxElements) {
            desc += "\(self[i])";
            if ( i < self.count - 1 ) {
                desc += ", "
            }
            if ( maxElements != self.count && i == ( maxElements - 1 ) ) {
                desc += "…"
            }
        }
        desc += "]";
        return desc;
    }
}

