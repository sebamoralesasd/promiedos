# frozen_string_literal: true

class PositionsController < ApplicationController
  def index
    @positions = PositionServices::Context.new(PositionServices::Ratio.new).execute
    @match_history = Match.order(created_at: :desc).limit(5)
  end
end
