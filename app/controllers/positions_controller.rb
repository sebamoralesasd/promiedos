# frozen_string_literal: true

class PositionsController < ApplicationController
  def index
    @players = Positions.new.call
    @match_history = Match.order(created_at: :desc).limit(5)
  end
end
