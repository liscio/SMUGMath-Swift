//
//  SMUGMathTests.swift
//  SMUGMathTests
//
//  Created by Christopher Liscio on 2014-06-20.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import XCTest
import SMUGMath

class SMUGMathTests: XCTestCase {
    
    func testConstruction() {
        var a = RealVector<Float>(components: [1, 2, 3]);
        XCTAssertTrue( a[0] == 1 && a[1] == 2 && a[2] == 3, "Did not get expected components" );
    }
    
    func testAddition() {
        var a = RealVector<Float>(components: [1, 2, 3]);
        var b = RealVector<Float>(components: [1, 2, 3]);
        
        var c = a + b;
        
        XCTAssertEqualWithAccuracy( c[0], 2.0, FLT_EPSILON );
        XCTAssertEqualWithAccuracy( c[1], 4.0, FLT_EPSILON );
        XCTAssertEqualWithAccuracy( c[2], 6.0, FLT_EPSILON );
    }
    
    func testMultiplication() {
        var a = RealVector<Float>(components: [1, 2, 3]);
        var b = RealVector<Float>(components: [1, 2, 3]);
        
        var c = a * b;
        
        XCTAssertEqualWithAccuracy( c[0], 1.0, FLT_EPSILON );
        XCTAssertEqualWithAccuracy( c[1], 4.0, FLT_EPSILON );
        XCTAssertEqualWithAccuracy( c[2], 9.0, FLT_EPSILON );
    }
    
    func testFFT() {
        var a = RealVector<Float>(count: 2048, repeatedValue: 0)
        a[0] = 1.0
        
        var setup = create_fft_setup(2048)
        
        var result = fft(setup, a, 2048)
        println( "result is \(result)" )
    }
    
    func testRanging() {
        var a = RealVector<Float>(count: 1024, repeatedValue: 0)
        for i in 0..a.count {
            a[i] = Float(i)
        }
        
        var b = a[0..10]
        println( "b is \(b)")
        
        var c = a[3..17]
        println( "c is \(c)")
        
        a.withRealVectorInRange(7...14) {
            vector in
            println( "subvector is \(vector)" )
        }
    }
    
    func testBlockFFT() {
        let totalSignalLength = 1024 * 1024
        let blockSize = 1024
        let skipLength = 256
        
        var setup = create_fft_setup(blockSize)
        
        let fakeSignal = RealVector<Float>(count: totalSignalLength, repeatedValue: 0)
        
        let blockCount = totalSignalLength / skipLength

        for i in 0..blockCount {
            let startIndex = i*skipLength
            let endIndex = startIndex + blockSize
            if ( endIndex >= totalSignalLength ) {
                // TODO: Figure out padding
                break;
            }
            
            fakeSignal.withRealVectorInRange(startIndex..endIndex) {
                let result = fft( setup, $0, blockSize )
                let realSpectra = abs(result[1...result.count/2])
            }
        }
        
        
    }
}
