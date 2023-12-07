require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'associations' do
    it { is_expected.to respond_to(:images) }
  end

  describe 'factory' do
    it 'is valid' do
      expect(user).to be_valid
    end
  end
end

