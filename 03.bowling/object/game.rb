# frozen_string_literal: true

class Game
  def initialize(input)
    shots = input.split(',').map { |s| Shot.new(s) }
    @frames = build_frames(shots)
  end

  def total_score
    @frames.sum { |frame| score_for(frame) }
  end

  private

  def build_frames(shots)
    frames = [Frame.new(1)]
    shots.each do |shot|
      frames << Frame.new(frames.size + 1) if frames.last.full?
      frames.last.throw_shot(shot)
    end
    frames
  end

  def score_for(frame)
    bonus = if frame.last_frame? then 0
            elsif frame.strike?  then next_shots(frame).first(2).sum(&:pin)
            elsif frame.spare?   then next_shots(frame).first(1).sum(&:pin)
            else 0
            end
    frame.base_score + bonus
  end

  def next_shots(frame)
    frame_index = @frames.index(frame)
    @frames[(frame_index + 1)..].flat_map(&:shots)
  end
end
