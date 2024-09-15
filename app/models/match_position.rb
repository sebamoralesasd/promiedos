# frozen_string_literal: true

class MatchPosition < ApplicationRecord
  belongs_to :match
  belongs_to :player

  validates :total_points, :total_matches, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :eligible_for_tournament, inclusion: { in: [true, false] }
end
