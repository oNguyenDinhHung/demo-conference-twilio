class Booking < ApplicationRecord
  belongs_to :account
  belongs_to :expert

  # Before a @booking save, please run @booking.set_access_code
  # to update access_code value
  def set_access_code
    code_for_account = (0...8).map { (48 + rand(10)).chr }.join
    code_for_expert = (0...8).map { (48 + rand(10)).chr }.join
    self.update(access_code: "#{code_for_account}.#{code_for_expert}")
  end

  # Run code_for_account, code_for_expert = @booking.get_access_code
  # to receive access code which be give to account and expert.
  def get_access_code
    access_code.split('.')
  end

  # Check if @booking is this time
  def is_this_time?
    Time.zone.now.between?(start, start + minutes.minutes)
  end
end
