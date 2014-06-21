//
//  Vector.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-20.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

struct Complex<T> {
    var real: T
    var imag: T
}

class RealVector<T> {
    var components: UnsafePointer<T>
    var count = 0
    init( count: Int ) {
        self.count = count
        components = UnsafePointer<T>.alloc(count)
    }
    deinit {
        components.destroy()
    }
    init( components: UnsafePointer<T>, count: Int ) {
        self.components = UnsafePointer<T>(components)
        self.count = count
    }
    convenience init(components: Array<T>) {
        self.init(count: components.count)
        self.components.initializeFrom(components)
        
    }
    
    subscript(i: Int) -> T {
        get {
            return components[i]
        }
        set (newValue) {
            components[i] = newValue
        }
    }
    
    subscript(range: Range<Int>) -> RealVector<T> {
        get {
            assert( range.startIndex < self.count )
            assert( range.endIndex < self.count )
            return RealVector<T>(components: components + range.startIndex, count: (range.endIndex - range.startIndex) )
        }
    }
    
    func withRealVectorInRange(range: Range<Int>, method:RealVector<T> -> Void) {
        assert( range.startIndex < self.count )
        assert( range.endIndex < self.count )
        method( RealVector<T>(components: components + range.startIndex, count: (range.endIndex - range.startIndex ) ) )
    }
}

func scale( a:RealVector<Float>, s:Float ) {
    vDSP_vsmul(a.components, vDSP_Stride(1), [s], a.components, vDSP_Stride(1), vDSP_Length(a.count) )
}

func scale( a:RealVector<Double>, s:Double ) {
    vDSP_vsmulD(a.components, vDSP_Stride(1), [s], a.components, vDSP_Stride(1), vDSP_Length(a.count) )
}

class SplitComplexVector<T> {
    var real: UnsafePointer<T>
    var imag: UnsafePointer<T>
    var count = 0
    
    init(count: Int) {
        self.count = count;
        real = UnsafePointer<T>.alloc(count)
        imag = UnsafePointer<T>.alloc(count)
    }
    deinit {
        real.destroy()
        imag.destroy()
    }
    
    subscript(i: Int) -> Complex<T> {
        return Complex<T>(real: real[i], imag: imag[i]);
    }
}

func create_fft_setup( length: Int ) -> FFTSetup {
    return vDSP_create_fftsetup( vDSP_Length(log2(CDouble(length))), FFTRadix(kFFTRadix2) );
}

func fft( setup: FFTSetup, x: RealVector<Float>, fft_length: Int ) -> SplitComplexVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2)
    var dspSplitComplex = DSPSplitComplex( realp: splitComplex.real, imagp: splitComplex.imag )
    var xAsComplex = UnsafePointer<DSPComplex>(x.components)
    vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
    
    return splitComplex
}

func fftr( setup: FFTSetup, x: RealVector<Float>, fft_length: Int ) -> RealVector<Float> {
    var splitComplex = SplitComplexVector<Float>(count: x.count / 2)
    var dspSplitComplex = DSPSplitComplex( realp: splitComplex.real, imagp: splitComplex.imag )
    var xAsComplex = UnsafePointer<DSPComplex>(x.components)
    vDSP_ctoz( xAsComplex, 2, &dspSplitComplex, 1, vDSP_Length(splitComplex.count) )
    
    vDSP_fft_zrip( setup, &dspSplitComplex, 1, vDSP_Length(log2(CDouble(fft_length))), FFTDirection(kFFTDirection_Forward) )
    
    var result = RealVector<Float>(count: fft_length)
    var resultAsComplex = UnsafePointer<DSPComplex>(result.components)
    vDSP_ztoc(&dspSplitComplex, 1, resultAsComplex, 2, vDSP_Length(splitComplex.count) )
    
    return result
}

// Operations on single-precision real vectors

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

// Operations on double-precision real vectors

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

extension Complex : Printable {
    var description: String {
        get {
            return "\(self.real)+\(self.imag)i";
        }
    }
}

// Enable debug printing
extension RealVector : Printable {
    var description: String {
    get {
        let maxElements = 25
        var desc = "["
        for i in 0..min(self.count, maxElements) {
            desc += "\(self[i])";
            if ( i < self.count - 1 ) {
                desc += ", "
            }
            if ( maxElements != self.count && i == ( maxElements - 1 ) ) {
                desc += "…"
            }
        }
        desc += "]";
        return desc;
    }
    }
}

extension SplitComplexVector : Printable {
    var description: String {
    get {
        let maxElements = 25
        var desc = "["
        for i in 0..min(self.count, maxElements) {
            desc += "\(self[i])";
            if ( i < self.count - 1 ) {
                desc += ", "
            }
            if ( maxElements != self.count && i == ( maxElements - 1 ) ) {
                desc += "…"
            }
        }
        desc += "]";
        return desc;
    }
    }
}