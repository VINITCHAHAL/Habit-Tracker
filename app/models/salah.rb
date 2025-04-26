class Salah < ApplicationRecord
  belongs_to :user

  before_save :ensure_masjid_consistency

  private

  def ensure_masjid_consistency
    self.prayed_in_masjid = false if salah_prayed == false
  end
end
