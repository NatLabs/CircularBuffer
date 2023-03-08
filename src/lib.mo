import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";

module {
    public class CircularBuffer<A>(init_max_capacity : Nat) {
        var start = 0;
        var count = 0;

        var max_capacity = init_max_capacity;

        var elems : [var ?A] = Array.init(8, null);

        func newCapacity() : Nat {
            if (elems.size() == 0) {
                return 8;
            };

            let new_capacity = Nat.min(elems.size() ** 2, max_capacity);

            if (new_capacity <= ((max_capacity - new_capacity) : Nat)) {
                new_capacity;
            } else {
                max_capacity;
            };

        };

        func reserve(_capacity : Nat) {
            if (_capacity < count) {
                Debug.trap "The capacity must be >= size in reserve";
            };

            let elems2 = Array.init<?A>(_capacity, null);

            var i = 0;
            while (i < count) {
                let j = get_index(i);
                elems2[i] := elems[j];
                i += 1;
            };

            start := 0;
            elems := elems2;
        };

        public func size() : Nat {
            count;
        };

        func get_index(i : Nat) : Nat {
            (start + i) % max_capacity;
        };

        public func get(i : Nat) : A {
            if (i >= count) {
                Debug.trap("CircularBuffer get(): Index out of bounds");
            };

            switch (elems[get_index(i)]) {
                case (?elem) elem;
                case (null) Debug.trap("CircularBuffer get(): Index out of bounds");
            };
        };

        public func getOpt(i : Nat) : ?A {
            if (i < count) {
                elems[get_index(i)];
            } else {
                null;
            };
        };

        public func removeLast() : ?A {
            if (count == 0) {
                return null;
            };

            let elem = elems[get_index(count)];
            count -= 1;

            elem;
        };

        public func remove(i : Nat) : A {
            if (i >= count) {
                Debug.trap("CircularBuffer remove(): Index out of bounds");
            };

            let index = get_index(i);
            let elem = get(index);

            let shift_left = i > count / 2;

            let iter = if (shift_left) {
                Iter.map<Nat, (Nat, Nat)>(
                    Iter.range(i + 2, count),
                    func(i : Nat) : (Nat, Nat) {
                        (get_index(i - 2), get_index(i - 1));
                    },
                );
            } else {
                Iter.map<Nat, (Nat, Nat)>(
                    Iter.range(1, i),
                    func(i : Nat) : (Nat, Nat) {
                        (get_index(i - 1), get_index(i));
                    },
                );
            };

            for ((i, j) in iter) {
                elems[j] := elems[i];
            };

            if (index == start) {
                start := get_index(1);
            };

            count -= 1;
            elem;
        };

        public func add(elem : A) {
            if (count == max_capacity) {
                Debug.trap("CircularBuffer add(): Buffer is full. Try increasing the capacity with setMaxCapacity()");
            };

            let index = get_index(count);

            if (index == elems.size()) {
                reserve(newCapacity());
            };

            elems[index] := ?elem;

            count += 1;
        };

        public func put(i : Nat, elem : A) {
            if (i >= count) {
                Debug.trap("CircularBuffer put(): Index out of bounds");
            };

            elems[get_index(i)] := ?elem;
        };

        public func removeFirst() : ?A {
            if (count == 0) {
                return null;
            };

            let elem = elems[start];
            start := get_index(1);
            count -= 1;

            elem;
        };

        public func push(elem : A) {
            if (count == max_capacity) {
                ignore removeFirst();
            };

            add(elem);
        };

        public func capacity() : Nat {
            max_capacity;
        };

        public func maxCapacity() : Nat {
            max_capacity;
        };

        public func setMaxCapacity(n : Nat) {
            if (n < count) {
                Debug.trap("CircularBuffer setMaxCapacity(): The capacity must be >= to the buffer size");
            };
            
            reserve(n);
            max_capacity := n;
        };

        public func clear() {
            start := 0;
            count := 0;
            reserve(8);
        };
    };

    /// Returns the values in the circular buffer as an array
    public func toArray<A>(circular_buffer : CircularBuffer<A>) : [A] {
        Array.tabulate(
            circular_buffer.size(),
            func(i : Nat) : A {
                circular_buffer.get(i);
            },
        );
    };

    public func fromArray<A>(array : [A]) : CircularBuffer<A> {
        let circular_buffer = CircularBuffer<A>(array.size());

        for (elem in array.vals()) {
            circular_buffer.add(elem);
        };

        circular_buffer;
    };
    
};
