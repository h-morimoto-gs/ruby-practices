# frozen_string_literal: true

class Shot
  STRIKE_MARK = 'X'
  ALL_PINS = 10

  def initialize(mark)
    @mark = mark
  end

  def score
    return ALL_PINS if @mark == STRIKE_MARK

    @mark.to_i
  end
end
