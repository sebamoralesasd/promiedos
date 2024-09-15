class CreateMatchPositions < ActiveRecord::Migration[7.0]
  def change
    create_table :match_positions do |t|
      t.references :match_player, null: false, foreign_key: true
      t.integer :position, null: false
      t.integer :total_matches, null: false
      t.integer :total_points, null: false
      t.integer :matches_won, null: false
      t.boolean :eligible_for_tournament

      t.timestamps
    end
  end
end
