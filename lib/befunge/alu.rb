module Befunge
  class ALU
    def initialize
      @stack = []
    end

    (0..9).each do |i|
      define_method("_#{i}") { push(i) }
    end

    [:+, :-, :*, :/, :%].each do |operator|
      define_method(operator) do
        a = @stack.pop
        b = @stack.pop
        push(b.send(operator, a))
      end
    end

    def !
      push(@stack.pop.zero? ? 1 : 0)
    end

    def compare
      push(@stack.pop > @stack.pop ? 1 : 0)
    end

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
