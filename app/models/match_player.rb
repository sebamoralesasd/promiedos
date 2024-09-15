# frozen_string_literal: true

class MatchPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :match
  has_one :match_position

  validates :points, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
