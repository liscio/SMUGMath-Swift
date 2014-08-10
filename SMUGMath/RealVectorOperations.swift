//
//  RealVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

/*
 * Multiplication
 */

public func * (left: [Float], right: [Float] ) -> [Float] {
    assert( left.count == right.count )
    var result = [Float](count: left.count, repeatedValue: 0)
    vDSP_vmul( left, 1, right, 1, &result, 1, vDSP_Length(left.count) )
    return result
}

public func * (left: [Double], right: [Double] ) -> [Double] {
    assert( left.count == right.count )
    var result = [Double](count: left.count, repeatedValue: 0)
    vDSP_vmulD( left, 1, right, 1, &result, 1, vDSP_Length(left.count) )
    return result
}

/*
 * Division
 */

public func / (left: [Float], right: [Float] ) -> [Float] {
    assert( left.count == right.count )
    var result = [Float]( count: left.count, repeatedValue: 0 )
    vDSP_vdiv( right, 1, left, 1, &result, 1, vDSP_Length(left.count) )
    return result;
}

public func / (left: [Double], right: [Double] ) -> [Double] {
    assert( left.count == right.count )
    var result = [Double]( count: left.count, repeatedValue: 0 )
    vDSP_vdivD( right, 1, left, 1, &result, 1, vDSP_Length(left.count) )
    return result;
}

/*
 * Addition
 */

public func + (left: [Float], right: [Float] ) -> [Float] {
    assert( left.count == right.count )
    var result = [Float]( count: left.count, repeatedValue: 0 )
    vDSP_vadd( left, 1, right, 1, &result, 1, vDSP_Length(left.count) )
    return result
}

public func + (left: [Double], right: [Double] ) -> [Double] {
    assert( left.count == right.count )
    var result = [Double]( count: left.count, repeatedValue: 0 )
    vDSP_vaddD( left, 1, right, 1, &result, 1, vDSP_Length(left.count) )
    return result
}