require 'byebug'
require_relative 'vector'

module Befunge
  # A memory with two separate banks. One bank is to store the output of the
  # program, the other is to store the program code itself.
  # These banks have different accesses, with the program supporting random
  # access, the program bank supports append only.
  class Memory
    def initialize
      @output = ''
      @program = []
    end

    attr_writer :program
    # @return the stored content of the output memory bank.
    attr_reader :output

    # add en elem to the end of the output bank
    def write(elem)
      @output << elem
    end

    # sets a cell in the program bank
    # @param vector [Befunge::Vector] the location of the cell
    # @param elem the value to set
    def []=(vector, elem)
      # be careful here, @program[vector.y][vector.x] = elem doesn't do what you
      # want
      row = @program[vector.y]
      row[vector.x] = elem
      @program[vector.y] = row
    end

    # @param vector [Befunge::Vector] the location of the cell
    # @return the cell content of the program bank
    def [](vector)
      @program[vector.y][vector.x]
    end
  end
end
