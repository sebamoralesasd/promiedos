class AddNumberToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :number, :integer, null: false, default: 0
  end
end
