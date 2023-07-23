# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :match_players
  has_many :matches, through: :match_players

  validates :name, presence: true
end
