require "rails_helper"

RSpec.describe UserImageRoomChannel, type: :channel do
  let(:current_user) { create(:user) }
  
  before { stub_connection current_user: current_user }
  
  subject { subscribe }
  
  context "when connects to right room" do
    it { is_expected.to be_confirmed }
    it { is_expected.to have_stream_from("user_image_room:#{current_user.id}") }
  end
end