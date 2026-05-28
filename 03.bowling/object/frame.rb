# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(number)
    @shots = []
    @frame_number = number
  end

  def throw_shot(shot)
    @shots << shot
  end

  def base_score
    @shots.sum(&:pin)
  end

  def strike?
    @shots.first.pin == 10
  end

  def spare?
    base_score == 10 && !strike?
  end

  def last_frame?
    @frame_number == 10
  end

  def score(next_shots)
    bonus = if last_frame? then 0
            elsif strike?  then next_shots.first(2).sum(&:pin)
            elsif spare?   then next_shots.first(1).sum(&:pin)
            else 0
            end
    base_score + bonus
  end

  def full?
    return false if @shots.empty?
    return @shots.size == 3 if last_frame?

    strike? || @shots.size == 2
  end
end
