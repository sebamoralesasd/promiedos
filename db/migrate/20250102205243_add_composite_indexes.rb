class AddCompositeIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :match_players, %i[match_id player_id], unique: true,
                                                      name: 'index_match_players_on_match_id_and_player_id'
    add_index :match_positions, %i[match_id player_id], unique: true,
                                                        name: 'index_match_positions_on_match_id_and_player_id'
  end
end
