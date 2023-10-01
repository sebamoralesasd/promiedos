class CreateTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.belongs_to :champion, foreign_key: { to_table: :players, on_delete: :nullify }

      t.timestamps
    end

    add_reference :matches, :tournament, foreign_key: true
    t = Tournament.create!(name: 'Torneo de invierno', start_date: Date.new(2023, 6, 21),
                           end_date: Date.new(2023, 9, 21))
    Match.all.each do |m|
      m.update!(tournament: t)
    end
  end
end
