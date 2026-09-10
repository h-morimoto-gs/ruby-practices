# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  FRAME_COUNT = 10
  LAST_FRAME_INDEX = FRAME_COUNT - 1
  SHOTS_PER_FRAME = 2

  def initialize(marks)
    marks = marks.split(',')
    @frames = []

    (FRAME_COUNT - 1).times do
      frame = if marks.first == Shot::STRIKE_MARK
                Frame.new(marks.shift)
              else
                Frame.new(*marks.shift(SHOTS_PER_FRAME))
              end
      @frames.push(frame)
    end

    @frames.push(Frame.new(*marks))
  end

  def score
    FRAME_COUNT.times.sum { |i| frame_score(i) }
  end

  private

  def last_frame?(index)
    index == LAST_FRAME_INDEX
  end

  def frame_score(index)
    frame = @frames[index]

    return frame.score if last_frame?(index)
    return frame.score + strike_bonus(index) if frame.strike?
    return frame.score + spare_bonus(index) if frame.spare?

    frame.score
  end

  def strike_bonus(index)
    next_frame = @frames[index + 1]

    if next_frame.strike? && !last_frame?(index + 1)
      next_frame.first_shot.score + @frames[index + 2].first_shot.score
    else
      next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def spare_bonus(index)
    @frames[index + 1].first_shot.score
  end
end
