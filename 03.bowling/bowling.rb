#!/usr/bin/env ruby
# frozen_string_literal: true

shots = ARGV[0].split(',').map { |s| s == 'X' ? 10 : s.to_i }

# フレームの開始位置を計算する
i = 0
frame_starts = 10.times.map do
  pos = i
  # ストライクなら次のフレームは1投後、そうでなければ2投後
  i += shots[i] == 10 ? 1 : 2
  pos
end

# スコアを計算する
score = frame_starts.sum do |shot_index|
  if shots[shot_index] == 10
    shots[shot_index..(shot_index + 2)].sum
  elsif shots[shot_index...(shot_index + 2)].sum == 10
    shots[shot_index..(shot_index + 2)].sum
  else
    shots[shot_index..(shot_index + 1)].sum
  end
end

puts score
