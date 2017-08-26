class Befunge
  attr_reader :output

  def initialize(program)
    @program = program.split("\n")
    @output = ''
    @string_mode = false
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
      @trampoline = false
    end

    def _?
      @direction = [:<, :>, :^, :v].sample
    end

    def _(elem)
      @direction = elem.zero? ? :> : :<
    end

    def |(elem)
      @direction = elem.zero? ? :v : :^
    end

    def trampoline!
      @trampoline = true
    end

    def move!
      self.x += (@trampoline ? 2 : 1) * DIRECTIONS[@direction].x
      self.y += (@trampoline ? 2 : 1) * DIRECTIONS[@direction].y
      @trampoline = false
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

  def operator
    @program[@controller.y][@controller.x]
  end

  def run
    step while operator != '@'
  end

  def step
    dispatch
    @controller.move!
    self
  end

  private

  def dispatch
    if @string_mode
      @alu.push(operator.ord)
    else
      case operator
      when '`'      then @alu.compare
      when ':'      then @alu.dupl
      when '\\'     then @alu.swap
      when '$'      then @alu.pop
      when /[0-9]/  then @alu.send("_#{operator}")
      when /[<>^v]/ then @controller.direction = operator.to_sym
      when '?'      then @controller._?
      when /[_|]/   then @controller.send(operator, @alu.pop)
      when '.'      then write
      when ','      then write(:chr)
      when '"'      then string_mode!
      when ' '      then
      when 'p'      then put!
      else send(operator)
      end
    end
  end

  def write(message = :to_s)
    @output << @alu.pop.send(message)
    self
  end

  def string_mode!
    @string_mode = @string_mode.!
  end

  def put!
    y = @alu.pop
    x = @alu.pop
    v = @alu.pop
    @program[x][y] = v.chr
  end

  def get!
    y = @alu.pop
    x = @alu.pop
    @alu.push(@program[x][y].ord)
  end
end
