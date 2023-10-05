class MaxMatchesPlayed
  def resolve(tournament)
    # Get the maximum matches played by any player
    Player.joins(match_players: { match: :tournament })
          .where(tournaments: { id: tournament.id })
          .group('players.id')
          .order('COUNT(match_players.match_id) DESC')
          .first&.match_players&.count
  end
end
