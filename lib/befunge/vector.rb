module Befunge
  Vector = Struct.new :x, :y do
    def +(other)
      Vector.new(x + other.x, y + other.y)
    end

    def -(other)
      Vector.new(x - other.x, y - other.y)
    end

    def *(number)
      Vector.new(number * x, number * y)
    end
  end
end
