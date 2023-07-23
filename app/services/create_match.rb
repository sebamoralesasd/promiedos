# frozen_string_literal: true

class CreateMatch
  def call(players_names, winner_name)
    w = Player.find_by!(name: winner_name)
    m = Match.create!(winner: w)

    Player.where(name: players_names).each do |p|
      MatchPlayer.create!(match: m, player: p)
    end

    m
  end
end
