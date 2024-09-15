class AddRatioToMatchPositions < ActiveRecord::Migration[7.0]
  def change
    add_column :match_positions, :ratio, :decimal
  end
end
