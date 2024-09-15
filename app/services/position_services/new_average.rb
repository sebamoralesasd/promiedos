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
      match_position = match_positions.find_by(player_id:, match: Match.where(tournament:).last)
      eligible_for_tournament = match_position.eligible_for_tournament ? 1 : 0
      {
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

    def match_positions
      MatchPosition.joins(:match_player, :matches).where(matches: { tournament: })
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
