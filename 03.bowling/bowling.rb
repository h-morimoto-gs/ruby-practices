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
point = 10.times.sum do |i|
  frame = frames[i]
  next_frame = frames[i + 1]

  if i == 9
    frames[i..].flatten.sum
  elsif frame[0] == 10
    if next_frame[0] == 10
      10 + next_frame[0] + frames[i + 2][0]
    else
      10 + next_frame[0..1].sum
    end
  elsif frame.sum == 10
    10 + next_frame[0]
  else
    frame.sum
  end
end

puts point
