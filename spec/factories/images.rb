# spec/factories/images.rb
FactoryBot.define do
  factory :image do
    association :user
    trans_id { '1239012iaosd' }
    after(:build) do |image|
      image.file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')), filename: 'test_image.jpg', content_type: 'image/jpeg')
    end
  end
end
