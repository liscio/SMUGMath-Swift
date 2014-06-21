//
//  RealVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

func scale( a:RealVector<Float>, s:Float ) {
    vDSP_vsmul(a.components, 1, [s], a.components, 1, vDSP_Length(a.count) )
}

func scale( a:RealVector<Double>, s:Double ) {
    vDSP_vsmulD(a.components, 1, [s], a.components, 1, vDSP_Length(a.count) )
}

@infix func * (left: RealVector<Float>, right: RealVector<Float>) -> RealVector<Float> {
    assert( left.count == right.count );
    var result = RealVector<Float>(count: left.count);
    vDSP_vmul(left.components, 1, right.components, 1, result.components, 1, vDSP_Length(result.count));
    return result;
}

@infix func + (left: RealVector<Float>, right: RealVector<Float>) -> RealVector<Float> {
    assert( left.count == right.count );
    var result = RealVector<Float>(count: left.count);
    vDSP_vadd(left.components, 1, right.components, 1, result.components, 1, vDSP_Length(result.count));
    return result;
}

@infix func * (left: RealVector<Double>, right: RealVector<Double>) -> RealVector<Double> {
    assert( left.count == right.count );
    var result = RealVector<Double>(count: left.count);
    vDSP_vmulD(left.components, 1, right.components, 1, result.components, 1, vDSP_Length(result.count));
    return result;
}

@infix func + (left: RealVector<Double>, right: RealVector<Double>) -> RealVector<Double> {
    assert( left.count == right.count );
    var result = RealVector<Double>(count: left.count);
    vDSP_vaddD(left.components, 1, right.components, 1, result.components, 1, vDSP_Length(result.count));
    return result;
}

@infix func * (left: RealVector<Float>, right: Float) -> RealVector<Float> {
    var result = RealVector<Float>(count: left.count)
    vDSP_vsmul(left.components, 1, [right], left.components, 1, vDSP_Length(left.count))
    return result;
}

@infix func * (left: RealVector<Double>, right: Double) -> RealVector<Double> {
    var result = RealVector<Double>(count: left.count)
    vDSP_vsmulD(left.components, 1, [right], left.components, 1, vDSP_Length(left.count))
    return result;
}