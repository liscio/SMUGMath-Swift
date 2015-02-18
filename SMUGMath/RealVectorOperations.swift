//
//  RealVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

// MARK: Utilities

func operateOn<C: Unsafeable where C.Generator.Element == Float, C.Index == Int>( x: C, y: C, operation: (UnsafePointer<Float>, UnsafePointer<Float>, inout [Float], vDSP_Length) -> Void ) -> [Float] {
    assert( count(x) == count(y) )
    var result = [Float](count: count(x), repeatedValue: 0)
    
    x.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
        y.withUnsafeBufferPointer { (yPointer: UnsafeBufferPointer<Float>) -> Void in
            operation(xPointer.baseAddress, yPointer.baseAddress, &result, vDSP_Length(count(result)))
        }
    }
    
    return result
}

func operateOn<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( x: C, y: C, operation: (UnsafePointer<Double>, UnsafePointer<Double>, inout [Double], vDSP_Length) -> Void ) -> [Double] {
    assert( count(x) == count(y) )
    var result = [Double](count: count(x), repeatedValue: 0)
    
    x.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Double>) -> Void in
        y.withUnsafeBufferPointer { (yPointer: UnsafeBufferPointer<Double>) -> Void in
            operation(xPointer.baseAddress, yPointer.baseAddress, &result, vDSP_Length(count(result)))
        }
    }
    
    return result
}

// MARK: Multiplication

public func mul<C: Unsafeable where C.Generator.Element == Float, C.Index == Int>( var x: C, y: C ) -> [Float] {
    return operateOn(x, y) {
        vDSP_vmul($0, 1, $1, 1, &$2, 1, $3)
        return
    }
}

public func mul<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( var x: C, y: C ) -> [Double] {
    return operateOn(x, y) {
        vDSP_vmulD($0, 1, $1, 1, &$2, 1, $3)
        return
    }
}

public func *<C: Unsafeable where C.Generator.Element == Float, C.Index == Int>( var x: C, y: C ) -> [Float] {
    return mul( x, y )
}

public func *<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( var x: C, y: C ) -> [Double] {
    return mul( x, y )
}

// MARK: Division

public func div<C: Unsafeable where C.Generator.Element == Float, C.Index == Int>( var x: C, y: C ) -> [Float] {
    return operateOn(x, y) {
        // Note: Operands flipped because vdiv does 2nd param / 1st param
        vDSP_vdiv($1, 1, $0, 1, &$2, 1, $3)
        return
    }
}

public func div<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( var x: C, y: C ) -> [Double] {
    return operateOn(x, y) {
        // Note: Operands flipped because vdiv does 2nd param / 1st param
        vDSP_vdivD($1, 1, $0, 1, &$2, 1, $3)
        return
    }
}

public func /<C: Unsafeable where C.Generator.Element == Float, C.Index == Int>( var x: C, y: C ) -> [Float] {
    return div(x, y)
}

public func /<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( var x: C, y: C ) -> [Double] {
    return div(x, y)
}

// MARK: Addition

public func add<C: Unsafeable where C.Generator.Element == Float, C.Index == Int>( var x: C, y: C ) -> [Float] {
    return operateOn(x, y) {
        vDSP_vadd($0, 1, $1, 1, &$2, 1, $3)
        return
    }
}

public func add<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( var x: C, y: C ) -> [Double] {
    return operateOn(x, y) {
        vDSP_vaddD($0, 1, $1, 1, &$2, 1, $3)
        return
    }
}

// The below operators are ambiguous, as arrays can also be "added" together for appending

//public func +<C: Unsafeable where C.Generator.Element == Float, C.Index == Int>( var x: C, y: C ) -> [Float] {
//    return add(x, y)
//}
//
//public func +<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>( var x: C, y: C ) -> [Double] {
//    return add(x, y)
//}