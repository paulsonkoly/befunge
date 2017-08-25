class Befunge
  attr_reader :output

  def initialize(program)
    @program = program.split("\n")
    @output = ''
    @alu = ALU.new
    @controller = Controller.new
  end

  #############################################################################
  Vector = Struct.new :x, :y do
    def +(other)
      Vector.new(x: x + other.x, y: y + other.y)
    end
  end

  class Controller < Vector
    DIRECTIONS = { ">": Vector.new(1, 0),
                   "<": Vector.new(-1, 0),
                   "^": Vector.new(0, -1),
                   "v": Vector.new(0, 1) }.freeze
    attr_writer :direction

    def initialize
      super(0, 0)
      @direction = :>
    end

    def move!
      self.x += DIRECTIONS[@direction].x
      self.y += DIRECTIONS[@direction].y
      self
    end
  end

  #############################################################################
  class ALU
    def initialize
      @stack = []
    end

    (0..9).each do |i|
      define_method("_#{i}") { push(i) }
    end

    [:+, :-, :*, :/, :%].each do |operator|
      define_method(operator) do
        push(@stack.pop.send(operator, @stack.pop))
      end
    end

    def !
      push(@stack.pop.zero? ? 1 : 0)
    end

    def compare
      push(@stack.pop > @stack.pop ? 1 : 0)
    end

    def push(elem)
      @stack.push(elem)
      self
    end

    def pop
      @stack.pop
    end
  end

  def step
    dispatch(@program[@controller.y][@controller.x])
    @controller.move!
    self
  end

  private

  def dispatch(operator)
    case operator
    when '`'      then @alu.compare
    when /[0-9]/  then @alu.send("_#{operator}")
    when /[<>^v]/ then @controller.direction = operator.to_sym
    when '.'      then self.send(:write)
    else send(operator)
    end
  end

  def write
    @output << @alu.pop.to_s
    self
  end
end
