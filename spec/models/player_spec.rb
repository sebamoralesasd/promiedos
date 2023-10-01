require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'Relationships' do
    it { is_expected.to have_many(:match_players) }
  end
end
