# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :match_players
  has_many :matches, through: :match_players
  #has_many :tournament_players
  #has_many :tournaments, through: :tournament_players
  validates :name, presence: true
end
