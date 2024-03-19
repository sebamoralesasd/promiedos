# frozen_string_literal: true

class CreateMatch
  def call(players, winner_name)
    result = nil
    ActiveRecord::Base.transaction do
      w = Player.find_by!(name: winner_name)
      m = Match.create!(winner: w, tournament: Tournament.last, number:)
      players.each do |pl|
        name = pl[:name]
        points = pl[:points].to_i
        player = Player.find_by(name:)
        MatchPlayer.create!(match: m, player:, points:)
      end

      result = m
    end

    result
  end

  private

  def number
    last_match = Match.where(tournament: Tournament.last).last
    last_match.present? ? last_match.number + 1 : 1
  end
end
