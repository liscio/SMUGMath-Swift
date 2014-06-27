//
//  ComplexVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

func abs( x: SplitComplexVector<Float> ) -> RealVector<Float> {
    var result = RealVector<Float>( count: x.count, repeatedValue: 0 )
    var dspSplitComplex = DSPSplitComplex( realp: x.real, imagp: x.imag )
    
    vDSP_zvabs( &dspSplitComplex, 1, &result.components, 1, vDSP_Length(x.count) )
    
    return result
}

func abs( x: SplitComplexVector<Double> ) -> RealVector<Double> {
    var result = RealVector<Double>( count:x.count, repeatedValue: 0 )
    var dspSplitComplex = DSPDoubleSplitComplex( realp: x.real, imagp: x.imag )
    
    vDSP_zvabsD( &dspSplitComplex, 1, &result.components, 1, vDSP_Length(x.count) )
    
    return result
}