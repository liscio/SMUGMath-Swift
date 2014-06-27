//
//  Vector.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-20.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

struct RealVector<T> : Printable {
    var components: Array<T>
    
    init(components: Array<T>) {
        self.components = components
    }
    
    init(count: Int, repeatedValue: T) {
        components = Array<T>(count: count, repeatedValue: repeatedValue)
    }
    
    subscript(i: Int) -> T {
        get {
            return components[i]
        }
        set (newValue) {
            components[i] = newValue
        }
    }
    
    var count: Int {
        get {
            return components.count;
        }
    }
    
    subscript(range: Range<Int>) -> RealVector<T> {
        get {
            assert( range.startIndex < self.count )
            assert( range.endIndex < self.count )
            // TODO: Figure out what to do about adding a copy operation by coercing a Slice<T> to an Array<T>
            return RealVector<T>( components: Array(components[range]) )
        }
        set(newValue) {
            assert( range.startIndex < self.count )
            assert( range.endIndex < self.count )
            assert( newValue.count == ( range.endIndex - range.startIndex ) );
            for i in range.startIndex..range.endIndex {
                self[i] = newValue[i-range.startIndex]
            }
        }
    }
    
    func withRealVectorInRange(range: Range<Int>, method:RealVector<T> -> Void) {
        assert( range.startIndex < self.count )
        assert( range.endIndex < self.count )
        // TODO: Figure out what to do about adding a copy operation by coercing a Slice<T> to an Array<T>
        method( RealVector<T>( components: Array(components[range]) ) )
    }
    
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