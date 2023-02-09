import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

import ActorSpec "./utils/ActorSpec";

import CircularBuffer "../src/";

let {
    assertTrue;
    assertFalse;
    assertAllTrue;
    describe;
    it;
    skip;
    pending;
    run;
} = ActorSpec;

let success = run([
    describe(
        "CircularBuffer",
        [
            it(
                "add()",
                do {
                    let buffer = CircularBuffer.CircularBuffer<Nat>(3);

                    buffer.add(1);
                    buffer.add(2);
                    buffer.add(3);
                    buffer.push(4);
                    buffer.push(5);
                    buffer.push(6);
                    buffer.push(7);

                    assertAllTrue([
                        buffer.get(0) == 5,
                        buffer.get(1) == 6,
                        buffer.get(2) == 7,
                    ])
                },
            ),
            it("clear()", do{
                let buffer = CircularBuffer.CircularBuffer<Nat>(3);

                buffer.add(1);
                buffer.add(2);
                buffer.add(3);
                buffer.clear();
                buffer.push(4);
                buffer.push(5);
                buffer.push(6);
                buffer.push(7);

                assertAllTrue([
                    buffer.get(0) == 5,
                    buffer.get(1) == 6,
                    buffer.get(2) == 7,
                ])
            })
        ],
    ),
]);

if (success == false) {
    Debug.trap("\1b[46;41mTests failed\1b[0m");
} else {
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};
