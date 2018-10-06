module Befunge
  # The ALU logic of the {Befunge} interpreter. Operators pop their arguments
  # of the stack and push their results on the stack.
  class ALU
    def initialize
      @stack = []
    end

    #@!method _0
    #@!method _1
    #@!method _2
    #@!method _3
    #@!method _4
    #@!method _5
    #@!method _6
    #@!method _7
    #@!method _8
    #@!method _9
    # _number is a shorthand for {ALU#push}(number)
    #@return [ALU] self

    (0..9).each do |i|
      define_method("_#{i}") { push(i) }
    end

    #@!method +
    # Pushes the sum of two popped values on the stack
    #@return [ALU] self

    #@!method -
    # Pushes the difference of two popped values on the stack
    #@return [ALU] self

    #@!method *
    # Pushes the product of two popped values on the stack
    #@return [ALU] self

    #@!method /
    # Pushes the quotient of two popped values on the stack
    #@return [ALU] self

    #@!method %
    # Pushes the modulo of two popped values on the stack
    #@return [ALU] self

    [:+, :-, :*, :/, :%].each do |operator|
      define_method(operator) do
        a = @stack.pop
        b = @stack.pop
        push(b.send(operator, a))
      end
    end

    # If the pop from the stack is zero it pushes 1 otherwise pushes 0.
    # @return [ALU] self
    # @example
    #   alu = ALU.new
    #   alu._0.!.pop  # => 1
    #
    def !
      push(@stack.pop.zero? ? 1 : 0)
    end

    def compare
      push(@stack.pop < @stack.pop ? 1 : 0)
    end

    # pushes the elem from the top of the stack twice
    def dupl
      elem = pop || 0
      push(elem).push(elem)
    end

    def swap
      elem1 = pop
      elem2 = pop || 0
      push(elem1).push(elem2)
    end

    def push(elem)
      @stack.push(elem)
      self
    end

    def pop
      @stack.pop
    end
  end
end
