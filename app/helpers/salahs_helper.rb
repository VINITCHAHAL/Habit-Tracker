module SalahsHelper
  def format_date_range(start_date, end_date, view_type)
    if view_type == "weekly"
      "Week of #{start_date.strftime("%B %d")} - #{end_date.strftime("%B %d, %Y")}"
    else
      start_date.strftime("%B %Y")
    end
  end

  def progress_bar(value, max, css_class = "bg-indigo-600")
    percentage = max.zero? ? 0 : (value.to_f / max * 100).round(1)
    content_tag :div, class: "w-full bg-gray-200 rounded-full h-2.5" do
      content_tag :div, "", class: "#{css_class} h-2.5 rounded-full", style: "width: #{percentage}%"
    end
  end

  def prayer_status_badge(salah)
    if salah.salah_prayed
      content_tag :span, "✓ Prayed", class: "text-green-600"
    else
      content_tag :span, "✕ Missed", class: "text-red-600"
    end
  end

  def location_badge(salah)
    return unless salah.salah_prayed && salah.prayed_in_masjid
    content_tag :span, "📍 Masjid", class: "text-blue-600"
  end

  def format_time(datetime)
    datetime.strftime("%I:%M %p")
  end

  def format_date(date)
    date.strftime("%B %d, %Y")
  end

  def stat_card(value, label, color = "indigo")
    content_tag :div, class: "text-center p-4 bg-gray-50 rounded-lg" do
      safe_join([
        content_tag(:div, value, class: "text-3xl font-bold text-#{color}-600"),
        content_tag(:div, label, class: "text-sm text-gray-600")
      ])
    end
  end
end
