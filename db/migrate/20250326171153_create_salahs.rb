class CreateSalahs < ActiveRecord::Migration[8.1]
  def change
    create_table :salahs do |t|
      t.string :salah_name
      t.boolean :salah_prayed
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
