//
//  FFTOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

//protocol UnsafePointerable {
//    typealias ItemType
//    func withUnsafePointerToElements<R>(body: (UnsafePointer<ItemType>) -> R) -> R
//    var count: Int { get }
//}
//
//extension Array : UnsafePointerable {
//    typealias ItemType = T
//}
//extension Slice : UnsafePointerable {
//    typealias ItemType = T
//}

func create_fft_setup( length: Int ) -> FFTSetup {
    return vDSP_create_fftsetup( vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2) );
}

// Uncomment this and the stuff above, and the compiler currently crashes with Xcode6-Beta3. Bummer.
//func fft<T:UnsafePointerable>( setup: FFTSetup, x : T, fft_length: Int ) -> SplitComplexVector<Float> {
//    var splitComplex = SplitComplexVector<Float>(count: x.count / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
//    var dspSplitComplex = DSPSplitComplex( realp: splitComplex.real.withUnsafePointerToElements {$0}, imagp: splitComplex.imag.withUnsafePointerToElements { $0 } )
//
//    var xAsComplex = UnsafePointer<DSPComplex>( x.withUnsafePointerToElements {$0} )
//    vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
//    
//    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
//    
//    return splitComplex
//}

func fft( setup: FFTSetup, x: [Float], fft_length: Int ) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
    var dspSplitComplex = DSPSplitComplex( realp: splitComplex.real.withUnsafePointerToElements {$0}, imagp: splitComplex.imag.withUnsafePointerToElements { $0 } )
    
    x.withUnsafePointerToElements() { (elements: UnsafePointer<Float>) -> () in
        var xAsComplex = UnsafePointer<DSPComplex>(elements)
        vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    }
    
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
    
    return splitComplex
}

// TODO: Figure out how to avoid duplicating the FFT implementation for both [Float] and Slice<Float>
func fft( setup: FFTSetup, x: Slice<Float>, fft_length: Int ) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
    var dspSplitComplex = DSPSplitComplex( realp: splitComplex.real.withUnsafePointerToElements {$0}, imagp: splitComplex.imag.withUnsafePointerToElements { $0 } )
    
    x.withUnsafePointerToElements() { (elements: UnsafePointer<Float>) -> () in
        var xAsComplex = UnsafePointer<DSPComplex>(elements)
        vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    }
    
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
    
    return splitComplex
}