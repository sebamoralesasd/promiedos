# frozen_string_literal: true

class PositionsController < ApplicationController
  def index
    @tournament = Tournament.last
    @positions = PositionServices::Context.new(PositionServices::Ratio.new).execute(tournament: @tournament)
    @match_history = ::MatchHistory.new.resolve(@tournament)
  end
end
