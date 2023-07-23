class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.integer :order
      t.belongs_to :winner, null: false, foreign_key: { to_table: :players, on_delete: :nullify }
      t.timestamps
    end
  end
end
