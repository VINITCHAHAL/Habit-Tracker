module SalahsHelper
  def get_prayer_stats(salahs)
    prayer_names = [ "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha" ]
    stats = {
      prayers: {},
      total_expected: calculate_total_expected(@selected_date, @view_mode)
    }
    prayer_names.each do |prayer|
      prayer_records = salahs.where(salah_name: prayer)
      stats[:prayers][prayer] = {
        prayed_in_masjid: prayer_records.where(salah_prayed: true, prayed_in_masjid: true).count,
        prayed_at_home: prayer_records.where(salah_prayed: true, prayed_in_masjid: false).count,
        missed: prayer_records.where(salah_prayed: false).count
      }
    end
    stats
  end

  def calculate_total_expected(date, view_mode)
    prayers_per_day = 5
    days_in_period = case view_mode
    when "monthly"
      date.end_of_month.day
    when "weekly"
      7
    else
      1
    end
    prayers_per_day * days_in_period
  end
end
