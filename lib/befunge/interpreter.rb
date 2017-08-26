require_relative 'alu'
require_relative 'controller'
require_relative 'memory'

module Befunge
  class Interpreter
    def initialize(alu = Befunge::ALU.new,
                   controller = Befunge::Controller.new,
                   memory = Befunge::Memory.new)
      @string_mode = false
      @alu = alu
      @controller = controller
      @memory = memory
    end

    def output
      @memory.output
    end

    def run(program)
      @memory.program = program.split("\n")
      step while @memory[@controller.position] != '@'
    end

    private

    def step
      dispatch
      @controller.move!
      self
    end

    def dispatch
      operator = @memory[@controller.position]
      if @string_mode && operator != '"'
        @alu.push(operator.ord)
      else
        case operator
        when '`'        then @alu.compare
        when ':'        then @alu.dupl
        when '\\'       then @alu.swap
        when '$'        then @alu.pop
        when /[0-9]/    then @alu.send("_#{operator}")
        when /[-+*\/%]/ then @alu.send(operator)
        when /[<>^v]/   then @controller.direction = operator.to_sym
        when '?'        then @controller._?
        when /[_|]/     then @controller.send(operator, @alu.pop)
        when '.'        then @memory.write(@alu.pop.to_s)
        when ','        then @memory.write(@alu.pop.chr)
        when '"'        then string_mode!
        when ' '        then
        when 'p'        then put!
        when 'g'        then get!
        end
      end
    end

    def string_mode!
      @string_mode = @string_mode.!
    end

    def put!
      y = @alu.pop
      x = @alu.pop
      v = @alu.pop
      @memory[Vector.new(x, y)] = v.chr
    end

    def get!
      y = @alu.pop
      x = @alu.pop
      @alu.push(@memory[Vector.new(x, y)].ord)
    end
  end
end
