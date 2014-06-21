//
//  ComplexVector.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-21.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation

struct Complex<T> {
    var real: T
    var imag: T
}

class SplitComplexVector<T> {
    var real: UnsafePointer<T>
    var imag: UnsafePointer<T>
    var count = 0
    
    init(count: Int) {
        self.count = count
        real = UnsafePointer<T>.alloc(count)
        imag = UnsafePointer<T>.alloc(count)
    }
    init(real: UnsafePointer<T>, imag: UnsafePointer<T>, count: Int) {
        self.count = count
        self.real = real
        self.imag = imag
    }
    deinit {
        real.destroy()
        imag.destroy()
    }
    
    subscript(i: Int) -> Complex<T> {
        return Complex<T>(real: real[i], imag: imag[i]);
    }
    
    subscript(range: Range<Int>) -> SplitComplexVector<T> {
        get {
            assert( range.startIndex < self.count )
            assert( range.endIndex < self.count )
            return SplitComplexVector<T>(real: real + range.startIndex, imag: imag + range.startIndex, count: (range.endIndex - range.startIndex) )
        }
    }
}

extension Complex : Printable {
    var description: String {
    get {
        return "\(self.real)+\(self.imag)i";
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

