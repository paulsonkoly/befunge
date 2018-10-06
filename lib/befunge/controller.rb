require_relative 'vector'

module Befunge
  # Controller logic of the {Befunge} interpreter. Controlls the movement of
  # the instruction pointer on a 2D grid.
  class Controller
    # value is one of +'>'+, +'<'+, +'^'+, +'v'+ representing left, right, up and
    # down movement
    attr_writer :direction
    # current location of the cursor
    attr_reader :position

    def initialize
      @position = Vector.new(0, 0)
      @direction = :>
      @trampoline = false
    end

    # sets direction to a random value
    # @return [String] the set direction
    def _?
      @direction = [:<, :>, :^, :v].sample
    end

    # conditional set of the direction
    # @param elem if zero the new direction is :> otherwise it's :<
    def _(elem)
      @direction = elem.zero? ? :> : :<
    end

    # conditional set of the direction
    # @param elem if zero the new direction is :v otherwise it's :^
    def |(elem)
      @direction = elem.zero? ? :v : :^
    end

    # sets trampoline mode for the next {#move!}.
    def trampoline!
      @trampoline = true
    end

    # executes a movement on the cursor
    def move!
      @position += DIRECTIONS[@direction] * (@trampoline ? 2 : 1)
      @trampoline = false
      self
    end

    private

    DIRECTIONS = { ">": Vector.new(1, 0),
                   "<": Vector.new(-1, 0),
                   "^": Vector.new(0, -1),
                   "v": Vector.new(0, 1) }.freeze
  end
end
