require 'pry'

class MyFloat
  attr_accessor :significand
  attr_reader :exponent, :float

  def initialize(float)
    @float = float
    @significand = calculate_significand(float.to_s)
    @exponent = calculate_exponent(float.to_s)
  end

  def +(other)
    equalise_exponents(other)

    carry = @significand & other.significand # 3 & -2
    result = @significand ^ other.significand # 3 ^ -2

    while carry != 0
      shifted_carry = carry << 1
      carry = result & shifted_carry
      result = result ^ shifted_carry
    end

    MyFloat.new(to_f(result))
  end

  def -(other)
    new_float = MyFloat.new(-other.float)

    sorted_floats = [self, new_float].sort_by { |myfloat| myfloat.significand}
    larger = sorted_floats[0]
    smaller = sorted_floats[1]

    smaller.+(larger)
  end

  def *(other)
    equalise_exponents(other)
    array = []
    other.significand.times { array << self }
    array.inject(0) do |sum, n|
      p "SUM #{sum}"
      sum.+(n)
    end
  end

  def /(other)
    equalise_exponents(other)
  end

  private

  def calculate_significand(float)
    if !float.include? "."
      float += ".0"
    end

    significand = float.split(".").join.to_i
  end

  def calculate_exponent(float)
    if !float.include? "."
      float += ".0"
    end

    -(float.split(".")[1].length).to_i
  end

  def equalise_exponents(other)
    sorted_floats = [self, other].sort_by { |object| object.exponent }

    float_with_smallest_exponent = sorted_floats[1]
    float_with_largest_exponent = sorted_floats[0]

    significand = float_with_smallest_exponent.significand.to_s
    significand += "0" * (float_with_largest_exponent.exponent - float_with_smallest_exponent.exponent).abs
    float_with_smallest_exponent.significand = significand.to_i
  end

  def to_f(number)
    number.to_s.insert(@exponent - 1, ".")
  end
end
