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
        return components[i]
    }
    
    public init(zeros: Int) {
        components = ContiguousArray<ElementType>(count: zeros, repeatedValue: ElementType(0))
    }
    
    public init(ones: Int) {
        components = ContiguousArray<ElementType>(count: ones, repeatedValue: ElementType(1))
    }
}

extension VectorType {
    mutating func mutatingOperationWith(other: Self, operation: (UnsafeMutablePointer<ElementType>, UnsafePointer<ElementType>, Int) -> Void ) {
        assert( self.count == other.count )
        
        components.withUnsafeMutableBufferPointer { (inout myPointer: UnsafeMutableBufferPointer<ElementType>) -> Void in
            other.components.withUnsafeBufferPointer({ (otherPointer: UnsafeBufferPointer<Self.ElementType>) -> Void in
                operation(myPointer.baseAddress, otherPointer.baseAddress, self.count)
            })
        }
    }
    
    mutating func mutatingOperation(operation: (UnsafeMutablePointer<ElementType>, Int) -> Void ) {
        components.withUnsafeMutableBufferPointer { (inout myPointer: UnsafeMutableBufferPointer<ElementType>) -> Void in
            operation(myPointer.baseAddress, self.count)
        }
    }

    mutating func mutatingOperationWith(other: Self, operation: (UnsafePointer<Self.ElementType>, vDSP_Stride, UnsafePointer<Self.ElementType>, vDSP_Stride, UnsafeMutablePointer<Self.ElementType>, vDSP_Stride, vDSP_Length) -> Void ) {

        mutatingOperationWith(other) {
            operation($0, 1, $1, 1, $0, 1, vDSP_Length($2))
        }
    }
}

extension VectorType where Self.ElementType == Float {
    mutating func add(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vadd)
    }
    
    mutating func subtract(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vsub)
    }
    
    mutating func divideBy(other: Self) {
        // Operands for vdiv are reversed, and hence require a custom implementation here
        mutatingOperationWith(other) { vDSP_vdiv($1, 1, $0, 1, $0, 1, vDSP_Length($2)) }
    }
    
    mutating func scaleBy(scalar: Float) {
        components.withUnsafeMutableBufferPointer { (inout myPointer: UnsafeMutableBufferPointer<ElementType>) -> Void in
            vDSP_vsmul(myPointer.baseAddress, 1, [scalar], myPointer.baseAddress, 1, vDSP_Length(self.count))
        }
    }
}

extension VectorType where Self.ElementType == Double {
    mutating func add(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vaddD)
    }
    
    mutating func subtract(other: Self) {
        mutatingOperationWith(other, operation: vDSP_vsubD)
    }
    
    mutating func divideBy(other: Self) {
        // Operands for vdiv are reversed, and hence require a custom implementation here
        mutatingOperationWith(other) { vDSP_vdivD($1, 1, $0, 1, $0, 1, vDSP_Length($2)) }
    }
    
    mutating func scaleBy(scalar: Double) {
        components.withUnsafeMutableBufferPointer { (inout myPointer: UnsafeMutableBufferPointer<ElementType>) -> Void in
            vDSP_vsmulD(myPointer.baseAddress, 1, [scalar], myPointer.baseAddress, 1, vDSP_Length(self.count))
        }
    }
}
