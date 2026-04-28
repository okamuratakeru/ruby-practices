#!/usr/bin/env ruby
# frozen_string_literal: true

shots = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }

frames = []
i = 0
10.times do
  if shots[i] == 10
    frames << [shots[i]]
    i += 1
  else
    frames << [shots[i], shots[i + 1]]
    i += 2
  end
end
bonus = shots[i..]

score = 0
frames.each_with_index do |frame, idx|
  score += frame.sum
  next_shots = (frames[idx + 1..] + [bonus]).flatten.compact
  if frame == [10]
    score += next_shots[0..1].sum
  elsif frame.sum == 10
    score += next_shots[0]
  end
end

puts score
