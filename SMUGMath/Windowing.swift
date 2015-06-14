//
//  Windowing.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

extension VectorType where Self.ElementType == Float {
    public init(hanningWindowOfLength length: Int) {
        self.init(zeros: length)
        self.mutatingOperation { (myComponentPointer: UnsafeMutablePointer<Float>, length: Int) -> Void in
            vDSP_hann_window(myComponentPointer, vDSP_Length(length), 0)
        }
    }
    
    public init(hammingWindowOfLength length: Int) {
        self.init(zeros: length)
        self.mutatingOperation { (myComponentPointer: UnsafeMutablePointer<Float>, length: Int) -> Void in
            vDSP_hamm_window(myComponentPointer, vDSP_Length(length), 0)
        }
    }
}

extension VectorType where Self.ElementType == Double {
    public init(hanningWindowOfLength length: Int) {
        self.init(zeros: length)
        self.mutatingOperation { (myComponentPointer: UnsafeMutablePointer<Double>, length: Int) -> Void in
            vDSP_hann_windowD(myComponentPointer, vDSP_Length(length), 0)
        }
    }
    
    public init(hammingWindowOfLength length: Int) {
        self.init(zeros: length)
        self.mutatingOperation { (myComponentPointer: UnsafeMutablePointer<Double>, length: Int) -> Void in
            vDSP_hamm_windowD(myComponentPointer, vDSP_Length(length), 0)
        }
    }
}
