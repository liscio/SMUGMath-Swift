//
//  FFTOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

func create_fft_setup( length: Int ) -> FFTSetup {
    return vDSP_create_fftsetup( vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2) );
}

func fft( setup: FFTSetup, x: RealVector<Float>, fft_length: Int ) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2)
    var dspSplitComplex = DSPSplitComplex( realp: splitComplex.real, imagp: splitComplex.imag )

    x.components.withUnsafePointerToElements() { (elements: UnsafePointer<Float>) -> () in
        var xAsComplex = UnsafePointer<DSPComplex>(elements)
        vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    }
    
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
    
    return splitComplex
}