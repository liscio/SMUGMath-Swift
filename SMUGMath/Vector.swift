//
//  Vector.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2015-06-13.
//  Copyright © 2015 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

public protocol VectorType {
    typealias ElementType
    var components: ContiguousArray<ElementType> { get set }
    
    var count: Int { get }
    init(zeros: Int)
    
    subscript(i: Int) -> ElementType { get }
}

public struct Vector<T: FloatingPointType> : VectorType {
    public var components: ContiguousArray<T>
    
    public var count: Int {
        return components.count
    }
    
    public subscript (i: Int) -> T {
        get {
            return components[i]
        }
        set {
            components[i] = newValue
        }
    }
    
    public init(zeros: Int) {
        components = ContiguousArray<ElementType>(count: zeros, repeatedValue: ElementType(0))
    }
    
    public init(ones: Int) {
        components = ContiguousArray<ElementType>(count: ones, repeatedValue: ElementType(1))
    }
}

extension Vector : ArrayLiteralConvertible {
    public init(arrayLiteral elements: T...) {
        components = ContiguousArray<T>(elements)
    }
}

extension Vector : CustomStringConvertible {
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

extension Vector : Equatable {}
public func ==<V: VectorType where V.ElementType: Equatable>(lhs: V, rhs: V) -> Bool {
    return lhs.components == rhs.components
}

extension VectorType {
    mutating func mutatingOperationWith(other: Self, operation: (UnsafeMutablePointer<ElementType>, UnsafePointer<ElementType>, Int) -> Void ) {
        assert( self.count == other.count )
        
        components.withUnsafeMutableBufferPointer { (inout myPointer: UnsafeMutableBufferPointer<ElementType>) -> Void in
            other.components.withUnsafeBufferPointer { (otherPointer: UnsafeBufferPointer<Self.ElementType>) -> Void in
                operation(myPointer.baseAddress, otherPointer.baseAddress, myPointer.count)
            }
        }
    }
    
    mutating func mutatingOperation(operation: (UnsafeMutablePointer<ElementType>, Int) -> Void ) {
        components.withUnsafeMutableBufferPointer { (inout myPointer: UnsafeMutableBufferPointer<ElementType>) -> Void in
            operation(myPointer.baseAddress, myPointer.count)
        }
    }

    mutating func mutatingOperationWith(other: Self, operation: (UnsafePointer<Self.ElementType>, vDSP_Stride, UnsafePointer<Self.ElementType>, vDSP_Stride, UnsafeMutablePointer<Self.ElementType>, vDSP_Stride, vDSP_Length) -> Void ) {

        mutatingOperationWith(other) {
            operation($0, 1, $1, 1, $0, 1, vDSP_Length($2))
        }
    }
}

extension VectorType where Self.ElementType == Float {
    public mutating func add(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vadd)
    }
    
    public mutating func subtract(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vsub)
    }
    
    public mutating func multiplyBy(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vmul)
    }
    
    public mutating func divideBy(other: Self) {
        // Operands for vdiv are reversed, and hence require a custom implementation here
        mutatingOperationWith(other) { vDSP_vdiv($1, 1, $0, 1, $0, 1, vDSP_Length($2)) }
    }
    
    public mutating func scaleBy(scalar: Float) {
        components.withUnsafeMutableBufferPointer { (inout myPointer: UnsafeMutableBufferPointer<ElementType>) -> Void in
            vDSP_vsmul(myPointer.baseAddress, 1, [scalar], myPointer.baseAddress, 1, vDSP_Length(myPointer.count))
        }
    }
}

extension VectorType where Self.ElementType == Double {
    public mutating func add(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vaddD)
    }
    
    public mutating func subtract(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vsubD)
    }
    
    public mutating func multiplyBy(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vmulD)
    }
    
    public mutating func divideBy(other: Self) {
        // Operands for vdiv are reversed, and hence require a custom implementation here
        mutatingOperationWith(other) { vDSP_vdivD($1, 1, $0, 1, $0, 1, vDSP_Length($2)) }
    }
    
    public mutating func scaleBy(scalar: Double) {
        components.withUnsafeMutableBufferPointer { (inout myPointer: UnsafeMutableBufferPointer<ElementType>) -> Void in
            vDSP_vsmulD(myPointer.baseAddress, 1, [scalar], myPointer.baseAddress, 1, vDSP_Length(myPointer.count))
        }
    }
}
