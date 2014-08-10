//
//  FFTOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

public func create_fft_setup( length: Int ) -> FFTSetup {
    return vDSP_create_fftsetup( vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2) );
}

public func fft( setup: FFTSetup, var x: [Float], fft_length: Int ) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
    var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
    
    var xAsComplex = UnsafePointer<DSPComplex>( x.withUnsafeBufferPointer { $0.baseAddress } )
    vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )

    return splitComplex
}

// TODO: Figure out how to avoid duplicating the FFT implementation for both [Float] and Slice<Float>
public func fft( setup: FFTSetup, x: Slice<Float>, fft_length: Int ) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
    var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
    
    var xAsComplex = UnsafePointer<DSPComplex>( x.withUnsafeBufferPointer { $0.baseAddress } )
    vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
    
    return splitComplex
}