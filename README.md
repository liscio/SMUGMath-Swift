# SMUGMath (in Swift)

I'm trying to realize my SMUGMath library using the Swift language. SMUGMath was basically a set of ObjC vector classes that were backed by Accelerate.framework to perform various numerical operations.

When Swift was introduced, it got me excited about the possibilities to create a more expressive environment for building various signal processing algorithms.

In a perfect world I'd have a programming environment that approaches MATLAB in its terseness and expressiveness.

### Example Usage

```
let a = [Float](count: 2048, repeatedValue: 0)
// Fill a with stuff

let b = [Float](count: 2048, repeatedValue: 0)
// Fill b with stuff

let c = a * b // ooh, so exciting!

let window = hamming( 2048 )

let setup = create_fft_setup( 2048 )
let result = fft( setup, a * window, 2048 )

// Grab the magnitude of the spectrum
let magnitude = abs(result[1..<result.count/2])
```

### Wishlist (read: Things that likely won't happen...)

* "Everything is a Matrix" - Like MATLAB, it'd be nice if there really was no differentiation between the types. That's asking a lot, though. The new Accelerate stuff in Yosemite/iOS8 may help make that happen.

