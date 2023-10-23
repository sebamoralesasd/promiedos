# frozen_string_literal: true

class PositionsController < ApplicationController
  def index
    @tournament = Tournament.last
    @positions = PositionServices::Context.new(PositionServices::Average.new)
                                          .execute(tournament: @tournament, winner_points: 2)
  end

  def last
    match = Match.last
    @positions = PositionServices::Context.new(PositionServices::LastMatch.new)
                                          .execute(match:)
  end
end
