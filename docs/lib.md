# lib

## Type `CircularBuffer`
``` motoko no-repl
type CircularBuffer<A> = { size : () -> Nat; get : (Nat) -> A; getOpt : (Nat) -> ?A; removeLast : () -> ?A; remove : (Nat) -> A; add : (A) -> (); put : (Nat, A) -> (); removeFirst : () -> ?A; push : (A) -> (); capacity : () -> Nat; maxCapacity : () -> Nat; setMaxCapacity : (Nat) -> (); clear : () -> () }
```


## Function `CircularBuffer`
``` motoko no-repl
func CircularBuffer<A>(max_capacity : Nat) : CircularBuffer<A>
```


## Function `initWithFullCapacity`
``` motoko no-repl
func initWithFullCapacity<A>(max_capacity : Nat) : CircularBuffer<A>
```


## Function `toArray`
``` motoko no-repl
func toArray<A>(circular_buffer : CircularBuffer<A>) : [A]
```

Returns the values in the circular buffer as an array

## Function `fromArray`
``` motoko no-repl
func fromArray<A>(array : [A]) : CircularBuffer<A>
```

