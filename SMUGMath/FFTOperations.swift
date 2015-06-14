//
//  FFTOperations.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

public protocol FFTSetupType {
    typealias SetupType
    typealias DirectionType
    
    var setup: SetupType { get }
    init(length: Int, withDirection: DirectionType, sharingWith: SetupType?)
    
    static var forward: DirectionType { get }
    static var inverse: DirectionType { get }
}

public struct FFTSetup : FFTSetupType {
    public let setup: vDSP_DFT_Setup
    public init(length: Int, withDirection direction: vDSP_DFT_Direction, sharingWith otherSetup: vDSP_DFT_Setup?) {
        setup = vDSP_DFT_zrop_CreateSetup(otherSetup ?? nil, vDSP_Length(length), direction)
    }
    
    public static var forward: vDSP_DFT_Direction {
        return .FORWARD
    }
    
    public static var inverse: vDSP_DFT_Direction {
        return .INVERSE
    }
}

public struct FFTSetupD : FFTSetupType {
    public let setup: vDSP_DFT_SetupD
    public init(length: Int, withDirection direction: vDSP_DFT_Direction, sharingWith otherSetup: vDSP_DFT_SetupD?) {
        setup = vDSP_DFT_zrop_CreateSetupD(otherSetup ?? nil, vDSP_Length(length), direction)
    }
    
    public static var forward: vDSP_DFT_Direction {
        return .FORWARD
    }
    
    public static var inverse: vDSP_DFT_Direction {
        return .INVERSE
    }
}

public protocol FFTContextType {
    typealias SetupType
    
    var length: Int { get }
    var forwardSetup: SetupType { get }
    var inverseSetup: SetupType { get }
}

public struct FFTContext<SetupType: FFTSetupType> : FFTContextType {
    public let length: Int
    public let forwardSetup: SetupType
    public let inverseSetup: SetupType

    public init(length: Int) {
        self.length = length
        forwardSetup = SetupType(length: length, withDirection: SetupType.forward, sharingWith: nil)
        inverseSetup = SetupType(length: length, withDirection: SetupType.inverse, sharingWith: forwardSetup.setup)
    }
}

extension VectorType where Self.ElementType == Float {
    public func dft(context: FFTContext<FFTSetup>) -> SplitComplexVector<Float> {
        var splitComplex = SplitComplexVector<Float>(count: self.count / 2, repeatedValue: Complex<Float>(real: 0, imag: 0))
        
        splitComplex.real.components.withUnsafeMutableBufferPointer { (inout realp: UnsafeMutableBufferPointer<ElementType>) -> Void in
            splitComplex.imag.components.withUnsafeMutableBufferPointer { (inout imagp: UnsafeMutableBufferPointer<ElementType>) -> Void in
                self.components.withUnsafeBufferPointer { (myp: UnsafeBufferPointer<Float>) -> Void in
                    let dspSplitComplex = DSPSplitComplex(realp: realp.baseAddress, imagp: imagp.baseAddress)
                    let selfAsComplex = UnsafePointer<DSPComplex>(myp.baseAddress)
                    vDSP_ctoz(selfAsComplex, 2, [dspSplitComplex], 1, vDSP_Length(realp.count))
                    vDSP_DFT_Execute(context.forwardSetup.setup, dspSplitComplex.realp, dspSplitComplex.imagp, dspSplitComplex.realp, dspSplitComplex.imagp)
                }
            }
        }
        
        return splitComplex
    }
}

extension VectorType where Self.ElementType == Double {
    public func dft(context: FFTContext<FFTSetupD>) -> SplitComplexVector<Double> {
        var splitComplex = SplitComplexVector<Double>(count: self.count / 2, repeatedValue: Complex<Double>(real: 0, imag: 0))
        
        splitComplex.real.components.withUnsafeMutableBufferPointer { (inout realp: UnsafeMutableBufferPointer<ElementType>) -> Void in
            splitComplex.imag.components.withUnsafeMutableBufferPointer { (inout imagp: UnsafeMutableBufferPointer<ElementType>) -> Void in
                self.components.withUnsafeBufferPointer { (myp: UnsafeBufferPointer<Double>) -> Void in
                    let dspSplitComplex = DSPDoubleSplitComplex(realp: realp.baseAddress, imagp: imagp.baseAddress)
                    let selfAsComplex = UnsafePointer<DSPDoubleComplex>(myp.baseAddress)
                    vDSP_ctozD(selfAsComplex, 2, [dspSplitComplex], 1, vDSP_Length(realp.count))
                    vDSP_DFT_ExecuteD(context.forwardSetup.setup, dspSplitComplex.realp, dspSplitComplex.imagp, dspSplitComplex.realp, dspSplitComplex.imagp)
                }
            }
        }
        
        return splitComplex
    }
}

extension SplitComplexVectorType where Self.VectorType == Vector<Float> {
    public func withUnsafeBufferPointers(operation: (UnsafeBufferPointer<Float>, UnsafeBufferPointer<Float>) -> Void) {
        self.real.components.withUnsafeBufferPointer { (realp: UnsafeBufferPointer<Float>) -> Void in
            self.imag.components.withUnsafeBufferPointer { (imagp: UnsafeBufferPointer<Float>) -> Void in
                operation(realp, imagp)
            }
        }
    }
    
    public mutating func withUnsafeMutableBufferPointers(operation: (UnsafeMutableBufferPointer<Float>, UnsafeMutableBufferPointer<Float>) -> Void) {
        self.real.components.withUnsafeMutableBufferPointer { (inout realp: UnsafeMutableBufferPointer<Float>) -> Void in
            self.imag.components.withUnsafeMutableBufferPointer { (inout imagp: UnsafeMutableBufferPointer<Float>) -> Void in
                operation(realp, imagp)
            }
        }
    }
}

extension SplitComplexVectorType where Self.VectorType == Vector<Double> {
    public func withUnsafeBufferPointers(operation: (UnsafeBufferPointer<Double>, UnsafeBufferPointer<Double>) -> Void) {
        self.real.components.withUnsafeBufferPointer { (realp: UnsafeBufferPointer<Double>) -> Void in
            self.imag.components.withUnsafeBufferPointer { (imagp: UnsafeBufferPointer<Double>) -> Void in
                operation(realp, imagp)
            }
        }
    }
    
    public mutating func withUnsafeMutableBufferPointers(operation: (UnsafeMutableBufferPointer<Double>, UnsafeMutableBufferPointer<Double>) -> Void) {
        self.real.components.withUnsafeMutableBufferPointer { (inout realp: UnsafeMutableBufferPointer<Double>) -> Void in
            self.imag.components.withUnsafeMutableBufferPointer { (inout imagp: UnsafeMutableBufferPointer<Double>) -> Void in
                operation(realp, imagp)
            }
        }
    }
}

extension SplitComplexVectorType where Self.VectorType == Vector<Float> {
    public mutating func idft(context: FFTContext<FFTSetup>) -> Vector<Float> {
        var result = Vector<Float>(zeros: self.count * 2)
        
        self.withUnsafeBufferPointers { (realp: UnsafeBufferPointer<Float>, imagp: UnsafeBufferPointer<Float>) -> Void in
            let splitComplex = DSPSplitComplex(realp: unsafeBitCast(realp.baseAddress, UnsafeMutablePointer<Float>.self), imagp: unsafeBitCast(imagp.baseAddress, UnsafeMutablePointer<Float>.self))
            vDSP_DFT_Execute(context.inverseSetup.setup, splitComplex.realp, splitComplex.imagp, splitComplex.realp, splitComplex.imagp)
            
            result.components.withUnsafeMutableBufferPointer { (inout resultp: UnsafeMutableBufferPointer<Float>) -> Void in
                let resultAsComplex = UnsafeMutablePointer<DSPComplex>(resultp.baseAddress)
                vDSP_ztoc([splitComplex], 1, resultAsComplex, 2, vDSP_Length(realp.count))
            }
        }
        
        return result
    }
}

extension SplitComplexVectorType where Self.VectorType == Vector<Double> {
    public mutating func idft(context: FFTContext<FFTSetupD>) -> Vector<Double> {
        var result = Vector<Double>(zeros: self.count * 2)
        
        self.withUnsafeBufferPointers { (realp: UnsafeBufferPointer<Double>, imagp: UnsafeBufferPointer<Double>) -> Void in
            let splitComplex = DSPDoubleSplitComplex(realp: unsafeBitCast(realp.baseAddress, UnsafeMutablePointer<Double>.self), imagp: unsafeBitCast(imagp.baseAddress, UnsafeMutablePointer<Double>.self))
            vDSP_DFT_ExecuteD(context.inverseSetup.setup, splitComplex.realp, splitComplex.imagp, splitComplex.realp, splitComplex.imagp)
            
            result.components.withUnsafeMutableBufferPointer { (inout resultp: UnsafeMutableBufferPointer<Double>) -> Void in
                let resultAsComplex = UnsafeMutablePointer<DSPDoubleComplex>(resultp.baseAddress)
                vDSP_ztocD([splitComplex], 1, resultAsComplex, 2, vDSP_Length(realp.count))
            }
        }
        
        return result
    }
}


