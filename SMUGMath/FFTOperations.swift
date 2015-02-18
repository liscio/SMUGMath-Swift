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

public func create_fft_setupD( length: Int ) -> FFTSetup {
    return vDSP_create_fftsetupD( vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2) );
}

public func fft<C: Unsafeable where C.Generator.Element == Float, C.Index == Int>(setup: FFTSetup, x: C, fft_length: Int) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: count(x) / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
    var dspSplitComplex = DSPSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
    
    x.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Float>) -> Void in
        var xAsComplex = UnsafePointer<DSPComplex>( xPointer.baseAddress )
        vDSP_ctoz(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
        vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward))
    }
    
    return splitComplex
}

public func fft<C: Unsafeable where C.Generator.Element == Double, C.Index == Int>(setup: FFTSetup, x: C, fft_length: Int) -> SplitComplexVector<Double> {
    var splitComplex = SplitComplexVector<Double>(count: count(x) / 2, repeatedValue: Complex<Double>(real: 0, imag: 0))
    var dspSplitComplex = DSPDoubleSplitComplex( realp: &splitComplex.real, imagp: &splitComplex.imag )
    
    x.withUnsafeBufferPointer { (xPointer: UnsafeBufferPointer<Double>) -> Void in
        var xAsComplex = UnsafePointer<DSPDoubleComplex>( xPointer.baseAddress )
        vDSP_ctozD(xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count))
        vDSP_fft_zripD(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward))
    }
    
    return splitComplex
}

public func ifft(setup: FFTSetup, var X: SplitComplexVector<Float>, fft_length: Int) -> [Float] {
    var result = [Float](count: fft_length, repeatedValue: 0)
    var dspSplitComplex = DSPSplitComplex( realp: &X.real, imagp: &X.imag )
    
    result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Float>) -> Void in
        var resultAsComplex = UnsafeMutablePointer<DSPComplex>( resultPointer.baseAddress )
        vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Inverse))
        vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(X.count))
    }
    
    return result
}

public func ifft(setup: FFTSetup, var X: SplitComplexVector<Double>, fft_length: Int) -> [Double] {
    var result = [Double](count: fft_length, repeatedValue: 0)
    var dspSplitComplex = DSPDoubleSplitComplex( realp: &X.real, imagp: &X.imag )
    
    result.withUnsafeBufferPointer { (resultPointer: UnsafeBufferPointer<Double>) -> Void in
        var resultAsComplex = UnsafeMutablePointer<DSPDoubleComplex>( resultPointer.baseAddress )
        vDSP_fft_zripD(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Inverse))
        vDSP_ztocD(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(X.count))
    }
    
    return result
}