# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = second_mark && Shot.new(second_mark)
    @third_shot = third_mark && Shot.new(third_mark)
  end

  def score
    [first_shot, second_shot, third_shot].compact.sum(&:score)
  end

  def strike?
    first_shot.score == Shot::ALL_PINS
  end

  def spare?
    !strike? && (first_shot.score + second_shot.score == Shot::ALL_PINS)
  end
end
