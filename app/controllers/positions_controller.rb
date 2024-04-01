# frozen_string_literal: true

class PositionsController < ApplicationController
  def index
    @tournament = Tournament.where(tournament_type: 'liga').last
    @positions = PositionServices::Context.new(PositionServices::Average.new)
                                          .execute(tournament: @tournament, winner_points: 2)
  end

  def last
    match = Match.where(tournament: Tournament.where(tournament_type: 'liga').last).last
    @positions = PositionServices::Context.new(PositionServices::LastMatch.new)
                                          .execute(match:)
  end
end
