# befunge

Partial implementation of the befunge interpreter.

The project was an experiment in TDD, with clearly separated and separately tested modules, using dependency injection techniques.

The interpreter is loosely modelled after a simplistic view of a CPU with modules for [ALU](/lib/befunge/alu.rb), [Controller](/lib/befunge/controller.rb) [Memory](/lib/befunge/memory.rb), and the full interpreter [Interpreter](/lib/befunge/interpreter.rb) that wires these modules together.

At the module level they are independently tested, using test doubles for across module message sending.

## Lessons learned

Interestingly we have reached full module level coverage around [d5f12d9f](../../commit/d5f12d9f4670f72f70d902882a0b635bbd12066c), but after integration testing there were more bugs appearing. These were mainly wiring bugs between modules, and some mis-specced module behaviour.
