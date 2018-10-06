module Befunge
  # A 2 dimensional vector.
  Vector = Struct.new :x, :y do
    # entry wise sum of vectors
    # @param other the other vector
    def +(other)
      Vector.new(x + other.x, y + other.y)
    end

    # entry wise subtraction of vectors
    # @param other the other vector
    def -(other)
      Vector.new(x - other.x, y - other.y)
    end

    # constant multiplication of vectors
    # @param number [Numeric] a constant
    def *(number)
      Vector.new(number * x, number * y)
    end
  end
end
