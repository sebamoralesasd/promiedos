class AddTournamentTypeToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :tournament_type, :string, null: false, default: 'liga'

    ::Tournament.update_all(tournament_type: 'liga')
  end
end
