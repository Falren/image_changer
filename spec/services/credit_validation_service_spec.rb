require 'rails_helper'

RSpec.describe CreditValidationService do
  describe '#call' do
    let(:user) { create(:user) }
    let(:service) { described_class.new }
      
    subject { service.error }
  
    context 'when no user is provided' do
      let(:user) { nil }

      before { service.call(user) }

      it { is_expected.to eq('No user provided') }
    end

    context 'when user has no subscription' do
      
      before do 
        allow(user.user_subscription).to receive(:nil?).and_return(true) 
        service.call(user)
      end

      it { is_expected.to eq('No subscription') }
    end

    context 'when user has a subscription with zero credits' do
      
      before do 
        user.user_subscription.update(credit: 0)
        service.call(user)
      end

      it { is_expected.to eq('Insufficient credits') }
    end

    context 'when user has a subscription with credits' do
      it { is_expected.to be_nil }
    end
  end
end
