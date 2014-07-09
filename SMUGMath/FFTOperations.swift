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

func fft( setup: FFTSetup, x: [Float], fft_length: Int ) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2)
    var dspSplitComplex = DSPSplitComplex( realp: splitComplex.real, imagp: splitComplex.imag )

    x.withUnsafePointerToElements() { (elements: UnsafePointer<Float>) -> () in
        var xAsComplex = UnsafePointer<DSPComplex>(elements)
        vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    }
    
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
    
    return splitComplex
}

// TODO: Figure out how to avoid duplicating the FFT implementation for both [Float] and Slice<Float>
func fft( setup: FFTSetup, x: Slice<Float>, fft_length: Int ) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2)
    var dspSplitComplex = DSPSplitComplex( realp: splitComplex.real, imagp: splitComplex.imag )
    
    x.withUnsafePointerToElements() { (elements: UnsafePointer<Float>) -> () in
        var xAsComplex = UnsafePointer<DSPComplex>(elements)
        vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    }
    
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
    
    return splitComplex
}