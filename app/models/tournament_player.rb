# frozen_string_literal: true

class TournamentPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :tournament
end
