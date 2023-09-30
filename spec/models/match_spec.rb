require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'Relationships' do
    it { is_expected.to belong_to(:winner) }
    it { is_expected.to have_many(:match_players) }
  end
end
