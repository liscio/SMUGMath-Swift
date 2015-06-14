//
//  ComplexVectorOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

extension SplitComplexVectorType where ElementType == Float {
    public func abs() -> Vector<Float> {
        var result = Vector<Float>(zeros: self.count)
        
        real.components.withUnsafeBufferPointer { (realP: UnsafeBufferPointer<ElementType>) -> Void in
            imag.components.withUnsafeBufferPointer { (imagP: UnsafeBufferPointer<ElementType>) -> Void in
                let splitComplex = DSPSplitComplex(realp: unsafeBitCast(realP.baseAddress, UnsafeMutablePointer<Float>.self), imagp: unsafeBitCast(imagP.baseAddress, UnsafeMutablePointer<Float>.self))

                result.components.withUnsafeMutableBufferPointer { (inout resultP: UnsafeMutableBufferPointer<ElementType>) -> Void in
                    vDSP_zvabs([splitComplex], 1, resultP.baseAddress, 1, vDSP_Length(result.count))
                }
            }
        }
        
        return result
    }
}

extension SplitComplexVectorType where ElementType == Double {
    public func abs() -> Vector<Double> {
        var result = Vector<Double>(zeros: self.count)
        
        real.components.withUnsafeBufferPointer { (realP: UnsafeBufferPointer<ElementType>) -> Void in
            imag.components.withUnsafeBufferPointer { (imagP: UnsafeBufferPointer<ElementType>) -> Void in
                let splitComplex = DSPDoubleSplitComplex(realp: unsafeBitCast(realP.baseAddress, UnsafeMutablePointer<Double>.self), imagp: unsafeBitCast(imagP.baseAddress, UnsafeMutablePointer<Double>.self))
                
                result.components.withUnsafeMutableBufferPointer { (inout resultP: UnsafeMutableBufferPointer<ElementType>) -> Void in
                    vDSP_zvabsD([splitComplex], 1, resultP.baseAddress, 1, vDSP_Length(result.count))
                }
            }
        }
        
        return result
    }
}