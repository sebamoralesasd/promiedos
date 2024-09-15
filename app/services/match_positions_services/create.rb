# frozen_string_literal: true

module MatchPositionsServices
  class Create
    def execute(params)
      @params = params
      player_stats = []

      players.each do |player|
        # player_stats << MatchPosition.create!(stats(player))
        player_stats << stats(player)
      end

      add_position_value(player_stats)
    end

    private

    def add_position_value(stats)
      sort(stats).each_with_index do |st, i|
        st.merge!(position: i + 1)
      end
    end

    def stats(player)
      player_id = player.id

      player_total_matches = total_matches[player_id] || 0
      player_matches_won = matches_won[player_id] || 0
      points = total_points[player_id] || 0
      player_total_points = points.zero? ? 0 : points + (player_matches_won * winner_points)

      ratio = player_total_matches.zero? ? 0 : player_total_points.to_f / player_total_matches
      eligible_for_tournament = player_total_matches >= min_matches_required.to_i ? 1 : 0

      {
        match_player: match_player(player.id),
        total_matches: player_total_matches,
        total_points: player_total_points,
        matches_won: player_matches_won,
        eligible_for_tournament:,
        ratio:
      }
    end

    def tournament
      @tournament ||= @params[:tournament]
    end

    def winner_points
      @params[:winner_points]
    end

    def players
      @players ||= tournament.players.select('players.*')
    end

    # Get the maximum matches played by any player
    def max_matches_played
      @max_matches_played ||= ::MaxMatchesPlayed.new.resolve(@tournament)
    end

    # Calculate the minimum number of matches required to compete
    def min_matches_required
      @min_matches_required ||= max_matches_played ? (max_matches_played / 2.0).round : 0
    end

    def sort(stats)
      stats.sort_by! { |x| [-x[:eligible_for_tournament], -x[:ratio]] }
    end

    def total_matches
      matches.count
    end

    def matches
      MatchPlayer.joins(:match)
                 .where(player: @players.map(&:id), matches: { tournament_id: @tournament.id })
                 .group(:player_id)
    end

    def matches_won
      a = {}
      @tournament.players
                 .select("players.*,
                    COUNT(matches_winner.id) FILTER(WHERE matches_winner.tournament_id = #{@tournament.id}) AS matches_won")
                 .joins('LEFT JOIN matches matches_winner ON matches_winner.winner_id = players.id')
                 .where('matches_winner.tournament_id = :tournament_id OR matches_winner.tournament_id IS NULL', tournament_id: @tournament.id)
                 .group('players.id')
                 .each { |p| a[p.id] = p.matches_won }
      a
    end

    def total_points
      matches.sum(:points)
    end

    def match_player(player_id)
      ::MatchHistory.new.resolve(Tournament.last).first.match_players.find_by(player_id:)
    end
  end
end
