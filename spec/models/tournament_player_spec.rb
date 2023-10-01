require 'rails_helper'

RSpec.describe TournamentPlayer, type: :model do
  describe 'Relationships' do
    it { is_expected.to belong_to(:player) }
    it { is_expected.to belong_to(:tournament) }
  end
end
