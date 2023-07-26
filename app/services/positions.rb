# frozen_string_literal: true

class Positions
  def call
    # Get the maximum matches played by any player
    max_matches_played = Player.joins(:match_players)
                               .group('players.id')
                               .order('COUNT(match_players.match_id) DESC')
                               .first
                               &.match_players&.count

    # Calculate the minimum number of matches required to compete
    min_matches_required = max_matches_played ? (max_matches_played / 2) : 0

    players = Player.select('players.*, COUNT(match_players.match_id) AS total_matches, COUNT(matches_winner.id) AS matches_won, CAST(COUNT(matches_winner.id) AS float) / CAST(COUNT(match_players.match_id) AS float) AS ratio')
                    .joins('LEFT JOIN match_players ON match_players.player_id = players.id')
                    .joins('LEFT JOIN matches matches_winner ON matches_winner.id = match_players.match_id AND matches_winner.winner_id = players.id')
                    .group('players.id')
                    .order(Arel.sql('CAST(matches_won AS FLOAT) / total_matches DESC'))

    players.map do |player|
      {
        name: player.name,
        matches_won: player.matches_won,
        total_matches: player.total_matches,
        ratio: player.ratio,
        eligible_for_tournament: player.total_matches >= min_matches_required,
        match_history: player.matches.order('created_at DESC').limit(5)
      }
    end
  end

  def max_call
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
