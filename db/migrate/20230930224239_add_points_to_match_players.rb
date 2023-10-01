class AddPointsToMatchPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :match_players, :points, :integer

    MatchPlayer.all.each { |mp| mp.update!(points: 0) }
  end
end
