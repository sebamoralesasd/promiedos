class MaxMatchesPlayed
  def resolve(tournament)
    Player.joins(match_players: { match: :tournament })
          .where(tournaments: { id: tournament.id })
          .group('players.id')
          .order('COUNT(match_players.match_id) DESC')
          .limit(1)
          .pluck('COUNT(match_players.match_id)').first
  end
end
