#!/usr/bin/env ruby
# frozen_string_literal: true

shots = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }

i = 0
frame_starts = []
frames = 10.times.map do
  frame_starts << i
  if shots[i] == 10
    i += 1
    [shots[i - 1]]
  else
    i += 2
    [shots[i - 2], shots[i - 1]]
  end
end

score = frames.each_with_index.sum do |frame, idx|
  shot_idx = frame_starts[idx]
  frame_score = frame.sum
  if frame == [10]
    frame_score += shots[shot_idx + 1] + shots[shot_idx + 2]
  elsif frame.sum == 10
    frame_score += shots[shot_idx + 2]
  end
  frame_score
end

puts score
