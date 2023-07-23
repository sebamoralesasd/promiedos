class CreateMatchPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :match_players do |t|
      t.belongs_to :player, null: false, foreign_key: true
      t.belongs_to :match, null: false, foreign_key: true
      t.timestamps
    end
  end
end
