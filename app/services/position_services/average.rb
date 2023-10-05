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
                          .select("players.*,
                             COUNT(DISTINCT match_players.match_id) FILTER(WHERE matches_for_count.tournament_id = #{ActiveRecord::Base.connection.quote(tournament.id)}) AS total_matches,
                             COUNT(matches_winner.id) FILTER(WHERE matches_winner.tournament_id = #{ActiveRecord::Base.connection.quote(tournament.id)}) AS matches_won,
                             SUM(match_players.points) FILTER(WHERE matches_for_count.tournament_id = #{ActiveRecord::Base.connection.quote(tournament.id)}) AS total_points,
                             CAST(SUM(match_players.points) FILTER(WHERE matches_for_count.tournament_id = #{ActiveRecord::Base.connection.quote(tournament.id)}) AS float) /
                             NULLIF(COUNT(DISTINCT match_players.match_id) FILTER(WHERE matches_for_count.tournament_id = #{ActiveRecord::Base.connection.quote(tournament.id)}), 0) AS ratio, " \
        "CASE WHEN COUNT(DISTINCT match_players.match_id) FILTER(WHERE matches_for_count.tournament_id = #{ActiveRecord::Base.connection.quote(tournament.id)}) >= " + min_matches_required.to_i.to_s + ' THEN 1 ELSE 0 END AS eligible_for_tournament')
                          .joins('LEFT JOIN match_players ON match_players.player_id = players.id')
                          .joins('LEFT JOIN matches matches_winner ON matches_winner.id = match_players.match_id AND matches_winner.winner_id = players.id')
                          .joins('LEFT JOIN matches matches_for_count ON matches_for_count.id = match_players.match_id')
                          .where('matches_winner.tournament_id = ? OR matches_winner.tournament_id IS NULL', tournament.id)
                          .group('players.id')
                          .order(Arel.sql('eligible_for_tournament DESC, ratio DESC'))

      players.map do |player|
        {
          name: player.name,
          max_m: max_matches_played,
          matches_won: player.matches_won,
          total_matches: player.total_matches,
          total_points: player.total_points,
          ratio: player.ratio,
          eligible_for_tournament: player.eligible_for_tournament == 1 # ,
          # match_history: player.matches.order('created_at DESC').limit(5)
        }
      end
    end
  end
end
