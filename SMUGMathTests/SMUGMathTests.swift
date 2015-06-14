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
    
//    func testBlockFFT() {
//        let totalSignalLength = 1024 * 1024
//        let blockSize = 8192
//        let skipLength = 256
//        
//        var setup = create_fft_setup(blockSize)
//        
//        let fakeSignal = [Float](count: totalSignalLength, repeatedValue: 0)
//        
//        let blockCount = totalSignalLength / skipLength
//
//        for i in 0..<blockCount {
//            let startIndex = i*skipLength
//            let endIndex = startIndex + blockSize
//            if ( endIndex >= totalSignalLength ) {
//                // TODO: Figure out padding
//                break;
//            }
//            
//            let range = startIndex..<endIndex
//            let result = fft( setup, fakeSignal[range], blockSize )
//            let realSpectra = abs(result)[1...result.count/2]
//        }
//    }
}
