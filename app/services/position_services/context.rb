# frozen_string_literal: true

module PositionServices
  class Context
    def initialize(strategy)
      @strategy = strategy
    end

    def execute(params = nil)
      @strategy.execute(params)
    end
  end
end
