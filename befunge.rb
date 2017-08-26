require_relative 'lib/befunge/alu'
require_relative 'lib/befunge/controller'

module Befunge
  class Interpreter
    attr_reader :output

    def initialize(program,
                   alu = Befunge::ALU.new,
                   controller = Befunge::Controller.new)
      @program = program.split("\n")
      @output = ''
      @string_mode = false
      @alu = alu
      @controller = controller
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
end
