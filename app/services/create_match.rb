# frozen_string_literal: true

class CreateMatch
  def call(players_names, winner_name)
    result = nil
    ActiveRecord::Base.transaction do
      w = Player.find_by!(name: winner_name)
      m = Match.create!(winner: w)

      Player.where(name: players_names).each do |p|
        MatchPlayer.create!(match: m, player: p)
      end

      result = m
    end

    result
  end
end
