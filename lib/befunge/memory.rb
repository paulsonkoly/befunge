require 'byebug'
require_relative 'vector'

module Befunge
  class Memory
    def initialize
      @output = ''
      @program = []
    end

    attr_writer :program
    attr_reader :output

    def write(elem)
      @output << elem
    end

    def []=(vector, elem)
      # be careful here, @program[vector.y][vector.x] = elem doesn't do what you
      # want
      row = @program[vector.y]
      row[vector.x] = elem
      @program[vector.y] = row
    end

    def [](vector)
      @program[vector.y][vector.x]
    end
  end
end
