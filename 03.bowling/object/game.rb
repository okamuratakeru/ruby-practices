# frozen_string_literal: true

class Game
  def initialize(input)
    shots = input.split(',').map { |s| Shot.new(s) }
    @frames = build_frames(shots)
  end

  def total_score
    @frames.each_with_index.sum { |frame, i| frame.score(@frames[(i + 1)..]) }
  end

  private

  def build_frames(shots)
    frames = 10.times.map { |i| Frame.new(i + 1) }
    shot_index = 0
    frames.each do |frame|
      until frame.full?
        frame.throw_shot(shots[shot_index])
        shot_index += 1
      end
    end
    frames
  end
end
