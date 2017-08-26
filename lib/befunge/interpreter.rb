require_relative 'alu'
require_relative 'controller'

module Befunge
  class Interpreter
    attr_reader :output

    def initialize(alu = Befunge::ALU.new,
                   controller = Befunge::Controller.new,
                   memory = Befunge::Memory.new)
      @output = ''
      @string_mode = false
      @alu = alu
      @controller = controller
      @memory = memory
    end

    def run(program)
      @memory.program = program.split("\n")
      step while operator != '@'
    end

    private

    def operator
      @operator ||= @memory[@controller.position]
    end

    def step
      dispatch
      @controller.move!
      @operator = nil
      self
    end

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
        when '.'      then write(@alu.pop.to_s)
        when ','      then write(@alu.pop.chr)
        when '"'      then string_mode!
        when ' '      then
        when 'p'      then put!
        else send(operator)
        end
      end
    end

    def write(elem)
      @output << elem
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
end
