//
//  SMUGMathTests.swift
//  SMUGMathTests
//
//  Created by Christopher Liscio on 2014-06-20.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import XCTest
import Accelerate
import SMUGMath

class SMUGMathTests: XCTestCase {
    
    func testAddition() {
        var a : Vector<Float> = [1, 2, 3]
        let b : Vector<Float> = [1, 2, 3]
        
        a.add(b)
        
        XCTAssertEqualWithAccuracy( a[0], Float(2.0), accuracy: FLT_EPSILON );
        XCTAssertEqualWithAccuracy( a[1], Float(4.0), accuracy: FLT_EPSILON );
        XCTAssertEqualWithAccuracy( a[2], Float(6.0), accuracy: FLT_EPSILON );
    }
    
    func testMultiplication() {
        let a : Vector<Float> = [1, 2, 3]
        let b : Vector<Float> = [1, 2, 3]

        var c = a
        c.multiplyBy(b)
        
        XCTAssertEqualWithAccuracy( c[0], Float(1.0), accuracy: FLT_EPSILON );
        XCTAssertEqualWithAccuracy( c[1], Float(4.0), accuracy: FLT_EPSILON );
        XCTAssertEqualWithAccuracy( c[2], Float(9.0), accuracy: FLT_EPSILON );
    }
    
    func testFFT() {
        var a = Vector<Float>(zeros: 2048)
        a[0] = 1.0
        
        let context = FFTContext<SMUGMath.FFTSetup>(length: 2048)
        let result = a.dft(context)
        
        let absoluteValue = result.abs()
     
        print("The result(\(result.count)) is \(result)")
        print("The absolute value is \(absoluteValue)")
    }
    
    func testFFTIdentity() {
        var a = Vector<Float>(zeros: 2048)
        a[0] = 1.0
        
        let context = FFTContext<SMUGMath.FFTSetup>(length: 2048)
        let result = a.dft(context)
        
        var fftResult = result
        var inverse = fftResult.idft(context)
        inverse.scaleBy(1.0/(2.0 * 2048.0))
        
        XCTAssertEqual(a, inverse)
    }
    
    func testDoubleFFT() {
        var a = Vector<Double>(zeros: 2048)
        a[0] = 1.0
        
        let context = FFTContext<SMUGMath.FFTSetupD>(length: 2048)
        let result = a.dft(context)
        
        let absoluteValue = result.abs()
        
        print("The result(\(result.count)) is \(result)")
        print("The absolute value is \(absoluteValue)")
    }
    
    func testDoubleFFTIdentity() {
        var a = Vector<Double>(zeros: 2048)
        a[0] = 1.0
        
        let context = FFTContext<SMUGMath.FFTSetupD>(length: 2048)
        let result = a.dft(context)
        
        var fftResult = result
        var inverse = fftResult.idft(context)
        inverse.scaleBy(1.0/(2.0 * 2048.0))
        
        XCTAssertEqual(a, inverse)
    }
    
    func testRampCreation() {
        let largeVector = Vector<Float>(integersRangingFrom:0, to: 2048)
        XCTAssertEqual(largeVector.count, 2048)
        XCTAssertEqualWithAccuracy(largeVector[0], 0, accuracy: FLT_EPSILON)
        XCTAssertEqualWithAccuracy(largeVector[2047], 2047, accuracy: FLT_EPSILON)
    }

    func testDoubleRampCreation() {
        let largeVector = Vector<Double>(integersRangingFrom:0, to: 2048)
        XCTAssertEqual(largeVector.count, 2048)
        XCTAssertEqualWithAccuracy(largeVector[0], 0, accuracy: DBL_EPSILON)
        XCTAssertEqualWithAccuracy(largeVector[2047], 2047, accuracy: DBL_EPSILON)
    }
    
    func testRangedAccess() {
        let largeVector = Vector<Float>(integersRangingFrom:0, to: 2048)

        let range = 0..<128
        let ranged = largeVector[range]
        
        XCTAssertEqual(ranged.count, 128)
        XCTAssertEqualWithAccuracy(ranged[0], 0, accuracy: FLT_EPSILON)
        XCTAssertEqualWithAccuracy(ranged[127], 127, accuracy: FLT_EPSILON)
    }
    
    func testBlockFFT() {
        let totalSignalLength = 1024 * 1024
        let blockSize = 8192
        let skipLength = 256

        let context = FFTContext<SMUGMath.FFTSetup>(length: blockSize)
        let fakeSignal = Vector<Float>(zeros: totalSignalLength)
        let blockCount = fakeSignal.count / skipLength
        
        for i in 0..<blockCount {
            var range = (i*skipLength)..<(i*skipLength + blockSize)
            if ( range.endIndex > fakeSignal.count ) {
                break
            }
            
            let result = fakeSignal[range].dft(context)
            let _ = result.abs()[1...result.count/2]
        }
    }
    
    /// This is _obviously_ going to run slower since each map/filter needs to be evaluated. That said, it's also different in that it's expecting a list of vectors
    func testMapBlockFFT() {
        let totalSignalLength = 1024 * 1024
        let blockSize = 8192
        let skipLength = 256
        
        let context = FFTContext<SMUGMath.FFTSetup>(length: blockSize)
        let fakeSignal = Vector<Float>(zeros: totalSignalLength)
        let blockCount = fakeSignal.count / skipLength
        
        let fftRanges = Array<Int>(0..<blockCount)
            .map { $0 * skipLength }                    // Scale by the skip length
            .map { $0..<$0+blockSize }                  // Create ranges for each FFT slice
            .filter { $0.endIndex < fakeSignal.count }  // Don't let it exceed the length of the input

        let _ = fftRanges
            .map { (range: Range<Int>) -> VectorSlice<Float> in
                let X = fakeSignal[range].dft(context)
                return X.abs()[1...X.count/2]
            }
    }
}
