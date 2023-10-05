class MatchHistory
  def resolve(tournament)
    tournament.matches.order(created_at: :desc) 
  end
end
