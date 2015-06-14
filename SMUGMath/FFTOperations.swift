//
//  FFTOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

extension FFTSetup {
    init(singlePrecisionWithLength length: Int) {
        self = vDSP_create_fftsetup( vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2) )
    }
}

extension FFTSetupD {
    init(doublePrecisionWithLength length: Int) {
        self = vDSP_create_fftsetupD( vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2) )
    }
}

extension VectorType where Self.ElementType == Float {
    public func fft(setup: FFTSetup, length: Int) -> SplitComplexVector<Float> {
        var splitComplex = SplitComplexVector<Float>(count: self.count / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
        splitComplex.real.components.withUnsafeMutableBufferPointer { (inout realp: UnsafeMutableBufferPointer<ElementType>) -> Void in
            splitComplex.imag.components.withUnsafeMutableBufferPointer { (inout imagp: UnsafeMutableBufferPointer<ElementType>) -> Void in
                var dspSplitComplex = DSPSplitComplex(realp: realp.baseAddress, imagp: imagp.baseAddress)
                vDSP_fft_zrip(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(kFFTDirection_Forward))
            }
        }
        return splitComplex
    }
}

extension SplitComplexVectorType where Self.ElementType == Float {
    public func ifft(setup: FFTSetup, fft_length: Int) -> Vector<Float> {
        var result = Vector<Float>(zeros: fft_length)
        
        self.real.components.withUnsafeBufferPointer { (realp: UnsafeBufferPointer<Float>) -> Void in
            self.imag.components.withUnsafeBufferPointer { (imagp: UnsafeBufferPointer<Float>) -> Void in
                let splitComplex = DSPSplitComplex(realp: unsafeBitCast(realp.baseAddress, UnsafeMutablePointer<Float>.self), imagp: unsafeBitCast(imagp.baseAddress, UnsafeMutablePointer<Float>.self))
                
                result.components.withUnsafeMutableBufferPointer { (inout resultP: UnsafeMutableBufferPointer<Float>) -> Void in
                    let resultAsComplex = UnsafeMutablePointer<DSPComplex>(resultP.baseAddress)
                    vDSP_fft_zrip(setup, [splitComplex], 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Inverse))
                    vDSP_ztoc([splitComplex], 1, resultAsComplex, 2, vDSP_Length(self.count))
                }
            }
        }
        
        return result
    }
}

extension VectorType where Self.ElementType == Double {
    public func fft(setup: FFTSetup, length: Int) -> SplitComplexVector<Double> {
        var splitComplex = SplitComplexVector<Double>(count: self.count / 2, repeatedValue: Complex<Double>(real: 0, imag: 0))
        splitComplex.real.components.withUnsafeMutableBufferPointer { (inout realp: UnsafeMutableBufferPointer<ElementType>) -> Void in
            splitComplex.imag.components.withUnsafeMutableBufferPointer { (inout imagp: UnsafeMutableBufferPointer<ElementType>) -> Void in
                var dspSplitComplex = DSPDoubleSplitComplex(realp: realp.baseAddress, imagp: imagp.baseAddress)
                vDSP_fft_zripD(setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(length))), FFTDirection(kFFTDirection_Forward))
            }
        }
        return splitComplex
    }
}

extension SplitComplexVectorType where Self.ElementType == Double {
    public func ifft(setup: FFTSetup, fft_length: Int) -> Vector<Double> {
        var result = Vector<Double>(zeros: fft_length)
        
        self.real.components.withUnsafeBufferPointer { (realp: UnsafeBufferPointer<Double>) -> Void in
            self.imag.components.withUnsafeBufferPointer { (imagp: UnsafeBufferPointer<Double>) -> Void in
                let splitComplex = DSPDoubleSplitComplex(realp: unsafeBitCast(realp.baseAddress, UnsafeMutablePointer<Double>.self), imagp: unsafeBitCast(imagp.baseAddress, UnsafeMutablePointer<Double>.self))
                
                result.components.withUnsafeMutableBufferPointer { (inout resultP: UnsafeMutableBufferPointer<Double>) -> Void in
                    let resultAsComplex = UnsafeMutablePointer<DSPDoubleComplex>(resultP.baseAddress)
                    vDSP_fft_zripD(setup, [splitComplex], 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Inverse))
                    vDSP_ztocD([splitComplex], 1, resultAsComplex, 2, vDSP_Length(self.count))
                }
            }
        }
        
        return result
    }
}
