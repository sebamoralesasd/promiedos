require 'rails_helper'

RSpec.describe MatchPlayer, type: :model do
  describe 'Relationships' do
    it { is_expected.to belong_to(:player) }
    it { is_expected.to belong_to(:match) }
  end
end
