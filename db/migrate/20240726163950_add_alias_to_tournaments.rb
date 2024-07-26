class AddAliasToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :alias, :string, null: false, default: 'actual'
  end
end
