//
//  ComplexVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

extension SplitComplexVectorType where Self.VectorType == Vector<Float> {
    public func abs() -> Vector<Float> {
        var result = Vector<Float>(zeros: self.count)
        
        real.components.withUnsafeBufferPointer { (realP: UnsafeBufferPointer<Float>) -> Void in
            imag.components.withUnsafeBufferPointer { (imagP: UnsafeBufferPointer<Float>) -> Void in
                let splitComplex = DSPSplitComplex(realp: unsafeBitCast(realP.baseAddress, UnsafeMutablePointer<Float>.self), imagp: unsafeBitCast(imagP.baseAddress, UnsafeMutablePointer<Float>.self))

                result.components.withUnsafeMutableBufferPointer { (inout resultP: UnsafeMutableBufferPointer<Float>) -> Void in
                    vDSP_zvabs([splitComplex], 1, resultP.baseAddress, 1, vDSP_Length(resultP.count))
                }
            }
        }
        
        return result
    }
}

extension SplitComplexVectorType where Self.VectorType == Vector<Double> {
    public func abs() -> Vector<Double> {
        var result = Vector<Double>(zeros: self.count)
        
        real.components.withUnsafeBufferPointer { (realP: UnsafeBufferPointer<Double>) -> Void in
            imag.components.withUnsafeBufferPointer { (imagP: UnsafeBufferPointer<Double>) -> Void in
                let splitComplex = DSPDoubleSplitComplex(realp: unsafeBitCast(realP.baseAddress, UnsafeMutablePointer<Double>.self), imagp: unsafeBitCast(imagP.baseAddress, UnsafeMutablePointer<Double>.self))
                
                result.components.withUnsafeMutableBufferPointer { (inout resultP: UnsafeMutableBufferPointer<Double>) -> Void in
                    vDSP_zvabsD([splitComplex], 1, resultP.baseAddress, 1, vDSP_Length(resultP.count))
                }
            }
        }
        
        return result
    }
}