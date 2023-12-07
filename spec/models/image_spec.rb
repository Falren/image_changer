require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:image) { create(:image) }

  describe 'Associations' do
    it { expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to) }
  end

  describe 'Active Storage' do
    it { expect(image.file).to be_attached }
  end

  describe 'Factory' do
    it 'is valid' do
      expect(image).to be_valid
    end
  end
end
