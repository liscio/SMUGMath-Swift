//
//  Windowing.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

func hanning( length: Int ) -> [Float] {
    var window = [Float](count: length, repeatedValue: 0)
    vDSP_hann_window( &window, vDSP_Length(window.count), 0 )
    return window
}

func hanning( length: Int ) -> [Double] {
    var window = [Double](count: length, repeatedValue: 0)
    vDSP_hann_windowD( &window, vDSP_Length(window.count), 0 )
    return window
}

func hamming( length: Int ) -> [Float] {
    var window = [Float](count: length, repeatedValue: 0)
    vDSP_hamm_window( &window, vDSP_Length(window.count), 0 )
    return window
}

func hamming( length: Int ) -> [Double] {
    var window = [Double](count: length, repeatedValue: 0)
    vDSP_hamm_windowD( &window, vDSP_Length(window.count), 0 )
    return window
}
