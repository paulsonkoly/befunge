require_relative 'vector'
require 'forwardable'

module Befunge
  class Controller
    extend Forwardable

    DIRECTIONS = { ">": Vector.new(1, 0),
                   "<": Vector.new(-1, 0),
                   "^": Vector.new(0, -1),
                   "v": Vector.new(0, 1) }.freeze
    attr_writer :direction
    attr_reader :position

    def initialize
      @position = Vector.new(0, 0)
      @direction = :>
      @trampoline = false
    end

    def_delegator :@position, :x
    def_delegator :@position, :y

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
      @position += DIRECTIONS[@direction] * (@trampoline ? 2 : 1)
      @trampoline = false
      self
    end
  end
end
