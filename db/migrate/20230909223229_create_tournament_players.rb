class CreateTournamentPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_players do |t|
      t.references :player, null: false, foreign_key: true
      t.references :tournament, null: false, foreign_key: true

      t.timestamps
    end
    t = Tournament.first
    Player.all.each do |p|
      TournamentPlayer.create!(player: p, tournament: t)
    end
  end
end
