# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :matches
  has_many :tournament_players
  has_many :players, through: :tournament_players
  belongs_to :champion, foreign_key: 'champion_id', class_name: 'Player', optional: true
end
