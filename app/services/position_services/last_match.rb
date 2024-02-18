# frozen_string_literal: true

module PositionServices
  class LastMatch < Strategy
    def execute(params)
      match = params[:match]
      MatchPlayer.where(match:).order(points: :desc)
    end
  end
end
