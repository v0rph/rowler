class Game < ApplicationRecord
  has_many :frames

  after_create :init

  FINAL_FRAME = 10
  FIST_BONUS_FRAME = 11
  SECOND_BONUS_FRAME = 12

  def init
    (SECOND_BONUS_FRAME).times { self.frames << Frame.create }
    self.current_frame = 1
    self.finished = false
    self.save
  end

  def throw_ball(pins)
    self.errors.add(:base, message: "This game has ended.") and return false if self.finished
    self.errors.add(:base, message: "Invalid Play.") and return false if pins > get_current_frame.pins_left ||
                                                                         pins > Frame::MAX_PINS ||
                                                                         pins < 0
    get_current_frame.throw_ball(pins)
    score_game
    check_finished if self.current_frame >= FINAL_FRAME

    self.save
  end

  def get_frame(id)
    self.frames.order(:id)[id-1]
  end

  private

  def offset_frame(offset)
    self.frames.order(:id)[self.current_frame - 1 + offset]
  end

  def get_current_frame
    self.frames.order(:id)[self.current_frame-1]
  end

  def score_game
    if get_current_frame.closed?
      score_frame(self.current_frame)
      self.current_frame += 1
    elsif self.current_frame == FIST_BONUS_FRAME && offset_frame(-1).spare?
      self.score_extra_spare
    end


  end

  def score_frame(frame_number)
    add_retroactive_bonus(frame_number)

    previous_score = frame_number == 1 ? 0 : offset_frame(-1).points
    get_current_frame.add_points(previous_score + (Frame::MAX_PINS - get_current_frame.pins_left))
  end

  def check_finished
    self.finished = (self.current_frame > SECOND_BONUS_FRAME ) ||
                    (self.current_frame == FIST_BONUS_FRAME && !get_frame(FINAL_FRAME).strike? && !get_frame(FINAL_FRAME).spare?) ||
                    (get_frame(FINAL_FRAME).strike? && get_frame(FIST_BONUS_FRAME).closed? && !(get_frame(FIST_BONUS_FRAME).strike?)) ||
                    (get_frame(FINAL_FRAME).strike? && get_frame(FIST_BONUS_FRAME).strike? && get_frame(SECOND_BONUS_FRAME).first_throw >= 0) ||
                    (get_frame(FINAL_FRAME).spare? && get_frame(FIST_BONUS_FRAME).first_throw >= 0)
  end

  def add_retroactive_bonus(frame_number)
    if frame_number > 1
      if offset_frame(-1).spare?
        offset_frame(-1).add_points(get_current_frame.first_throw)
      elsif offset_frame(-1).strike?
        if frame_number > 2
          if offset_frame(-2).strike?
            offset_frame(-2).add_points(get_current_frame.first_throw)
            offset_frame(-1).add_points(get_current_frame.first_throw)
          end
        end
        offset_frame(-1).add_points(get_current_frame.first_throw + (get_current_frame.strike? ?  0 : get_current_frame.second_throw ))
      end
    end
  end

  def score_extra_spare
    get_frame(FINAL_FRAME).add_points(get_current_frame.first_throw)
  end

  def score
    self.current_frame >= FINAL_FRAME ? get_frame(FINAL_FRAME).points : offset_frame(-1).points
  end

end
