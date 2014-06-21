//
//  Vector.swift
//  SMUGMath
//
//  Created by Christopher Liscio on 2014-06-20.
//  Copyright (c) 2014 Christopher Liscio. All rights reserved.
//

import Foundation
import Accelerate

class RealVector<T> : Printable {
    var components: UnsafePointer<T>
    var count = 0
    init( count: Int ) {
        self.count = count
        components = UnsafePointer<T>.alloc(count)
    }
    init( components: UnsafePointer<T>, count: Int ) {
        self.components = UnsafePointer<T>(components)
        self.count = count
    }
    deinit {
        // Will this be a problem for the init( components, count ) case? In that instance, we're handed an UnsafePointer<T> that wasn't alloc()ed by us. Could it be that UnsafePointer<T> is smart enough to know whether it was alloc'd?
        components.destroy()
    }
    
    convenience init(components: Array<T>) {
        self.init(count: components.count)
        self.components.initializeFrom(components)
    }
    
    subscript(i: Int) -> T {
        get {
            return components[i]
        }
        set (newValue) {
            components[i] = newValue
        }
    }
    
    subscript(range: Range<Int>) -> RealVector<T> {
        get {
            assert( range.startIndex < self.count )
            assert( range.endIndex < self.count )
            return RealVector<T>(components: components + range.startIndex, count: (range.endIndex - range.startIndex) )
        }
    }
    
    func withRealVectorInRange(range: Range<Int>, method:RealVector<T> -> Void) {
        assert( range.startIndex < self.count )
        assert( range.endIndex < self.count )
        method( RealVector<T>(components: components + range.startIndex, count: (range.endIndex - range.startIndex ) ) )
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