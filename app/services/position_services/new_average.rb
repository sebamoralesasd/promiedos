# frozen_string_literal: true

module PositionServices
  class NewAverage < Strategy
    def execute(params)
      @params = params
      player_stats = []

      players.each do |player|
        player_stats << stats(player)
      end

      sort(player_stats)
    end

    private

    def stats(player)
      player_id = player.id
      match_position = match_positions.find_by(player_id:)
      eligible_for_tournament = match_position.eligible_for_tournament ? 1 : 0
      {
        relative_pos: relative_pos(player_id),
        name: player.name,
        id: player_id,
        total_matches: match_position.total_matches,
        total_points: match_position.total_points,
        matches_won: match_position.matches_won,
        ratio: match_position.ratio,
        eligible_for_tournament:,
        match_history: match_history(player_id)
      }
    end

    def relative_pos(player_id)
      mps = MatchPosition.order(match_id: :desc).where(player_id:, match: tournament_matches).last(2)
      return 0 if mps.count < 2 || mps.first.position == mps.last.position

      mps.first.position < mps.last.position ? 1 : -1
    end

    def tournament_matches
      Match.where(tournament:)
    end

    def match
      tournament_matches.last
    end

    def match_positions
      MatchPosition.where(match:)
    end

    def tournament
      @tournament ||= @params[:tournament]
    end

    def players
      @players ||= tournament.players.select('players.*')
    end

    def sort(stats)
      stats.sort_by! { |x| [-x[:eligible_for_tournament], -x[:ratio]] }
    end

    def match_history(player_id)
      ::MatchHistory.new.resolve(@tournament).joins(:match_players).where(match_players: { player_id: }).limit(5)
    end
  end
end
