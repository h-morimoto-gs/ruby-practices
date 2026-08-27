# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    marks = marks.split(',')
    @frames = []

    9.times do
      frame = if marks.first == 'X'
                Frame.new(marks.shift, '0')
              else
                Frame.new(*marks.shift(2))
              end
      @frames.push(frame)
    end

    @frames.push(Frame.new(*marks))
  end

  def score
    10.times.sum { |i| frame_score(i) }
  end

  private

  def frame_score(index)
    frame = @frames[index]

    return frame.score if index == 9
    return frame.score + strike_bonus(index) if frame.strike?
    return frame.score + spare_bonus(index) if frame.spare?

    frame.score
  end

  def strike_bonus(index)
    next_frame = @frames[index + 1]

    if next_frame.strike? && index != 8
      next_frame.first_shot.score + @frames[index + 2].first_shot.score
    else
      next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def spare_bonus(index)
    @frames[index + 1].first_shot.score
  end
end
