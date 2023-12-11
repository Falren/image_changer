
RSpec.describe UserSubscription, type: :model do
  let(:user) { create(:user) }
  let(:subscription) { create(:subscription) }

  describe 'validations' do
    subject(:user_subscription) { build(:user_subscription, user: user, subscription: subscription, credit: credit) }

    context 'when credit is greater than or equal to 0' do
      let(:credit) { 10 }

      it { is_expected.to be_valid }
    end

    context 'when credit is less than 0' do
      let(:credit) { -5 }

      it { is_expected.not_to be_valid }
      it { expect(user_subscription.errors[:credit]).to include('must be greater than or equal to 0') }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:subscription) }
  end
end