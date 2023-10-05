# frozen_string_literal: true

module PositionServices
  class Strategy
    def execute(params = nil)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end
