class Befunge
  attr_reader :output

  def initialize
    @output = ''
    @stack = []
  end

  (0..9).each do |i|
    define_method("_#{i}") { push(i) }
  end

  def write
    @output << @stack.pop.to_s
    self
  end

  [:+, :-, :*, :/, :%].each do |operator|
    define_method("_#{operator}") do
      @stack.push(@stack.pop.send(operator, @stack.pop))
      self
    end
  end

  def !
    @stack.push(@stack.pop.zero? ? 1 : 0)
  end

  private

  def push(elem)
    @stack.push << elem
    self
  end
end
