# frozen_string_literal: true

class PositionsController < ApplicationController
  def index
    @players = Positions.new.call
  end
end
