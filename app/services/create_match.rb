# frozen_string_literal: true

class CreateMatch
  def call(players, winner_name, created_by, tournament_type)
    raise StandardError, 'No se encuentra el ganador en la lista' unless players.include?(winner_name)

    result = nil
    ActiveRecord::Base.transaction do
      tournament = Tournament.where(tournament_type:).last
      w = Player.find_by!(name: winner_name.strip.downcase)
      created_by = Player.find_by!(name: created_by.strip.downcase)
      number = number(tournament)
      m = Match.create!(winner: w, tournament:, number:, created_by:)
      players.each do |pl|
        name = pl[:name].strip.downcase
        points = pl[:points].to_i
        player = Player.find_by(name:)
        MatchPlayer.create!(match: m, player:, points:)
      end

      result = m
    end

    result
  end

  private

  def number(tournament)
    last_match = Match.where(tournament:).last
    last_match.present? ? last_match.number + 1 : 1
  end
end
