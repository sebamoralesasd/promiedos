# frozen_string_literal: true

module PositionServices
  class Average < Strategy
    def execute(params)
      tournament = params[:tournament]
      # Get the maximum matches played by any player
      max_matches_played = ::MaxMatchesPlayed.new.resolve(tournament)
      # Calculate the minimum number of matches required to compete
      min_matches_required = max_matches_played ? (max_matches_played / 2) : 0

      players = tournament.players
                          .select('players.*, COUNT(match_players.match_id) AS total_matches, COUNT(matches_winner.id) AS matches_won, ' \
          'SUM(match_players.points) AS total_points, ' \
          'CAST(SUM(match_players.points) AS float) / NULLIF(COUNT(match_players.match_id), 0) AS ratio')
                          .joins('LEFT JOIN match_players ON match_players.player_id = players.id')
                          .joins('LEFT JOIN matches matches_winner ON matches_winner.id = match_players.match_id AND matches_winner.winner_id = players.id')
                          .group('players.id')
                          .order(Arel.sql('ratio DESC'))

      players.map do |player|
        {
          name: player.name,
          matches_won: player.matches_won,
          total_matches: player.total_matches,
          total_points: player.total_points,
          ratio: player.ratio,
          eligible_for_tournament: player.total_matches >= min_matches_required,
          match_history: player.matches.order('created_at DESC').limit(5)
        }
      end
    end
  end
end
