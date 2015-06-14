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
    public var real: T
    public var imag: T
}

public protocol SplitComplexVectorType {
    typealias VectorType
    
    var real: VectorType { get set }
    var imag: VectorType { get set }
    
    var count: Int { get }
}

public struct SplitComplexVector<T: FloatingPointType> : SplitComplexVectorType {
    public var real: Vector<T>
    public var imag: Vector<T>
    
    public init( real: Vector<T>, imag: Vector<T> ) {
        self.real = real
        self.imag = imag
    }
    
    public init( count: Int, repeatedValue: Complex<T> ) {
        self.real = Vector<T>(zeros: count)
        self.imag = Vector<T>(zeros: count)
    }
    
    public subscript(i: Int) -> Complex<T> {
        return Complex<T>(real: real[i], imag: imag[i]);
    }
    
    public var count: Int {
        get {
            return real.count
        }
    }
}

extension SplitComplexVector : Equatable {}
public func ==<V: SplitComplexVectorType where V.VectorType: Equatable>(lhs: V, rhs: V) -> Bool {
    return
        lhs.real == rhs.real &&
        lhs.imag == rhs.imag
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

