class MatchHistory
  def resolve(tournament)
    tournament.matches.order(created_at: :desc).limit(5)
  end
end
