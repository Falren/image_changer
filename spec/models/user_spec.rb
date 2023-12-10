require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  
  describe 'associations' do
    it { is_expected.to respond_to(:images) }
  end

  describe 'factory' do
    it { is_expected.to be_valid }
  end
end

