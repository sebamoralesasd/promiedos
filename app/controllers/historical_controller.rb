# frozen_string_literal: true

class HistoricalController < ApplicationController
  def index
    @positions = PositionServices::Context.new(PositionServices::Historical.new)
                                          .execute
  end
end
