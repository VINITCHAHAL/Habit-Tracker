class Salah < ApplicationRecord
  belongs_to :user

  PRAYERS_PER_DAY = 5
  VALID_SALAH_NAMES = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"].freeze
  validates :salah_name, presence: true, inclusion: { in: VALID_SALAH_NAMES }
  validates :salah_prayed, inclusion: { in: [true, false] }
  validate :unique_salah_per_day
  before_save :ensure_masjid_consistency

  scope :prayed, -> { where(salah_prayed: true) }
  scope :missed, -> { where(salah_prayed: false) }
  scope :in_masjid, -> { where(prayed_in_masjid: true) }
  scope :for_date_range, ->(start_date, end_date) { where(created_at: start_date.beginning_of_day..end_date.end_of_day) }
  scope :by_prayer_name, ->(name) { where(salah_name: name) }

  def self.expected_prayers_for_period(start_date, end_date)
    (start_date.to_date..end_date.to_date).count * PRAYERS_PER_DAY
  end

  def self.calculate_period_statistics(salahs, start_date, end_date)
    expected_count = expected_prayers_for_period(start_date, end_date)
    calculate_statistics_for(salahs, expected_count)
  end

  def self.calculate_prayer_statistics(salahs, start_date, end_date)
    expected_total = expected_prayers_for_period(start_date, end_date)
    expected_per_prayer = expected_total / PRAYERS_PER_DAY

    VALID_SALAH_NAMES.each_with_object({}) do |name, stats|
      prayer_salahs = salahs.by_prayer_name(name)
      stats[name] = calculate_statistics_for(prayer_salahs, expected_per_prayer)
    end
  end

  private

  def self.calculate_statistics_for(salahs, expected_count)
    actual_count = salahs.count
    prayed_count = salahs.prayed.count
    masjid_count = salahs.in_masjid.count

    {
      expected_count: expected_count,
      actual_count: actual_count,
      prayed_count: prayed_count,
      missed_count: actual_count - prayed_count,
      masjid_count: masjid_count,
      completion_rate: calculate_percentage(prayed_count, expected_count),
      recording_rate: calculate_percentage(actual_count, expected_count),
      masjid_rate: calculate_percentage(masjid_count, actual_count)
    }
  end

  def self.calculate_percentage(value, total)
    return 0.0 if total.zero?
    (value.to_f / total * 100).round(1)
  end

  def unique_salah_per_day
    return unless new_record? || salah_name_changed?
    
    if user.salahs.where(
      salah_name: salah_name,
      created_at: Time.zone.today.all_day
    ).where.not(id: id).exists?
      errors.add(:base, "You've already logged this Salah today.")
    end
  end

  def ensure_masjid_consistency
    self.prayed_in_masjid = false if salah_prayed == false
  end
end
