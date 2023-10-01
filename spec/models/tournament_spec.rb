require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe 'Relationships' do
    it { is_expected.to have_many(:matches) }
    it { is_expected.to have_many(:tournament_players) }
    it { is_expected.to belong_to(:champion).optional }
  end
end
