# frozen_string_literal: true

module PositionServices
  class Historical < Strategy
    def execute(_params)
      @players = Player.all
      player_stats = []

      @players.each do |player|
        player_id = player.id

        player_total_matches = total_matches[player_id] || 0
        player_matches_won = matches_won[player_id] || 0
        ratio = player_total_matches.zero? ? 0 : player_matches_won.to_f / player_total_matches

        # Store stats in a hash for further usage.
        player_stats << {
          name: player.name,
          total_matches: player_total_matches,
          matches_won: player_matches_won,
          ratio:,
          id: player.id
        }
      end

      sort(player_stats)
    end

    private

    def sort(stats)
      stats.sort_by! { |x| [-x[:ratio]] }
    end

    def total_matches
      MatchPlayer.joins(:match)
                 .where(player: @players.map(&:id))
                 .group(:player_id)
                 .count
    end

    def matches_won
      a = {}
      Player
        .select("players.*,
                    COUNT(matches_winner.id) AS matches_won")
        .joins('LEFT JOIN matches matches_winner ON matches_winner.winner_id = players.id')
        .group('players.id')
        .each { |p| a[p.id] = p.matches_won }
      a
    end
  end
end
