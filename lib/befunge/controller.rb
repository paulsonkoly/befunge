module Befunge
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
end
