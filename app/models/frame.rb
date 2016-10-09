class Frame < ApplicationRecord
  belongs_to :game

  after_create :init

  MAX_PINS = 10

  def init
    self.points       =  0
    self.first_throw  = -1
    self.second_throw = -1
    self.save
  end

  def throw_ball(pins)
    if self.current_throw == 1
      self.first_throw = pins
    else
      self.second_throw = pins
    end

    self.save
  end

  def pins_left
    return MAX_PINS - ([self.second_throw,0].max + [self.first_throw,0].max)
  end

  def add_points(extra_points)
    self.points += extra_points
    self.save
  end

  def current_throw
    self.first_throw < 0 ? 1 : 2
  end

  def strike?
    self.first_throw == MAX_PINS
  end

  def closed?
    strike? || self.second_throw >= 0
  end

  def spare?
    closed? && (self.first_throw + self.second_throw == MAX_PINS)
  end
end
