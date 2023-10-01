# frozen_string_literal: true

class CreateTournament
  def call(players_names, tournament_name)
    result = nil
    ActiveRecord::Base.transaction do
      m = Tournament.create!(name: tournament_name)

      Player.where(name: players_names).each do |p|
        TournamentPlayer.create!(match: m, player: p)
      end

      result = m
    end

    result
  end
end
