require "rails_helper"

RSpec.describe UserImageRoomChannel, type: :channel do
  let(:current_user) { create(:user) }
  
  before do
    stub_connection current_user: current_user
  end

  it "connects to right room" do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("user_image_room:#{current_user.id}")
  end
end