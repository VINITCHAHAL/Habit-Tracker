class AddPrayedInMasjidToSalahs < ActiveRecord::Migration[8.1]
  def change
    add_column :salahs, :prayed_in_masjid, :boolean, default: false
  end
end
