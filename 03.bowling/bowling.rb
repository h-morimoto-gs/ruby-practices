#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots.push(10)
    shots.push(0)
  else
    shots.push(s.to_i)
  end
end

frames = shots.each_slice(2).to_a

point = 0
9.times do |i|
  frame = frames[i]

  point += if frame[0] == 10 # ストライク
             if frames[i + 1][0] == 10
               10 + frames[i + 1][0] + frames[i + 2][0]
             else
               10 + frames[i + 1][0] + frames[i + 1][1]
             end
           elsif frame.sum == 10 # スペア
             10 + frames[i + 1][0]
           else
             frame.sum
           end
end

point += frames[9..].flatten.sum
puts point
