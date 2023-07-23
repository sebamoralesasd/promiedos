# frozen_string_literal: true

class Match < ApplicationRecord
  has_many :match_players
  has_many :players, through: :match_players
  belongs_to :winner, foreign_key: 'winner_id', class_name: 'Player'
  # belongs_to :player
end
