//
//  Windowing.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

func hanning( length: Int ) -> RealVector<Float> {
    var window = RealVector<Float>(count: length)
    vDSP_hann_window( window.components, vDSP_Length(window.count), 0 )
    return window
}

func hanning( length: Int ) -> RealVector<Double> {
    var window = RealVector<Double>(count: length)
    vDSP_hann_windowD( window.components, vDSP_Length(window.count), 0 )
    return window
}

func hamming( length: Int ) -> RealVector<Float> {
    var window = RealVector<Float>(count: length)
    vDSP_hamm_window( window.components, vDSP_Length(window.count), 0 )
    return window
}

func hamming( length: Int ) -> RealVector<Double> {
    var window = RealVector<Double>(count: length)
    vDSP_hamm_windowD( window.components, vDSP_Length(window.count), 0 )
    return window
}
