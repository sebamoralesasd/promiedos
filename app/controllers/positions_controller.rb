# frozen_string_literal: true

class PositionsController < ApplicationController
  def index
    tournament = Tournament.where(tournament_type: 'liga').last
    if tournament
      redirect_to position_path(id: tournament.alias)
    else
      # Handle the case where there are no matches
      redirect_to tournament, alert: 'No matches available for this tournament.'
    end
  end

  def show
    @all_tournaments = Tournament.where(tournament_type: 'liga')
    @tournament_index = if params[:id]
                          @all_tournaments.find_index do |tr|
                            tr.alias == params[:id]
                          end
                        else
                          @all_tournaments.length - 1
                        end

    @tournament = @all_tournaments[@tournament_index]
    @positions = PositionServices::Context.new(PositionServices::Average.new)
                                          .execute(tournament: @tournament, winner_points: 2)
    @last_match = ::Match.last
  end

  def last
    match = Match.where(tournament: Tournament.where(tournament_type: 'liga').last).last
    @positions = PositionServices::Context.new(PositionServices::LastMatch.new)
                                          .execute(match:)
  end
end
