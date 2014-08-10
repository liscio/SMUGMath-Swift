//
//  ComplexVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

public func abs( var x: SplitComplexVector<Float> ) -> [Float] {
    var result = [Float]( count: x.count, repeatedValue: 0 )

    var dspSplitComplex = DSPSplitComplex( realp: &x.real, imagp: &x.imag )
    vDSP_zvabs( &dspSplitComplex, 1, &result, 1, vDSP_Length(x.count) )
    
    return result
}

public func abs( var x: SplitComplexVector<Double> ) -> [Double] {
    var result = [Double]( count:x.count, repeatedValue: 0 )

    var dspSplitComplex = DSPDoubleSplitComplex( realp: &x.real, imagp: &x.imag )
    vDSP_zvabsD( &dspSplitComplex, 1, &result, 1, vDSP_Length(x.count) )
    
    return result
}