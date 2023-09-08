module PositionServices
  class MaxRatio < Strategy
    def execute
      max_matches_played = Player.select('COUNT(match_players.match_id) AS total_matches')
                                 .joins(:match_players)
                                 .group('players.id')
                                 .order('total_matches DESC')
                                 .first
                             &.total_matches

      return unless max_matches_played

      threshold = max_matches_played / 2

      players = Player.select('players.*, COUNT(match_players.match_id) AS total_matches, COUNT(matches_winner.id) AS matches_won')
                      .joins('LEFT JOIN match_players ON match_players.player_id = players.id')
                      .joins('LEFT JOIN matches matches_winner ON matches_winner.id = match_players.match_id AND matches_winner.winner_id = players.id')
                      .group('players.id')
                      .having('COUNT(match_players.match_id) >= ?', threshold)
                      .order(Arel.sql('CAST(matches_won AS FLOAT) / total_matches DESC'))

      players.each do |player|
        player_name = player.name
        matches_won = player.matches_won
        total_matches = player.total_matches

        output = "#{player_name}: #{matches_won} / #{total_matches}"
        puts output
      end
      players
    end
  end
end
