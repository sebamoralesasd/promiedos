# frozen_string_literal: true

class CreateTournament
  def call(players_names, tournament_name)
    result = nil
    ActiveRecord::Base.transaction do
      start_date = Tournament.last.end_date + 1.day
      m = Tournament.create!(name: tournament_name, start_date:, end_date: start_date + 3.months - 1.day)

      Player.where(name: players_names).each do |p|
        TournamentPlayer.create!(tournament: m, player: p)
      end

      result = m
    end

    result
  end
end
