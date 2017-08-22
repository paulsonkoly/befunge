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

  def plus
    @stack.push(@stack.pop + @stack.pop)
    self
  end

  private

  def push(elem)
    @stack.push << elem
    self
  end
end
