FactoryBot.define do
  factory :image do
    association :user
    trans_id { '1239012iaosd' }
    trait :with_image do
      after :build do |image|
        file_name = 'test_image.jpg'
        file_path = Rails.root.join('spec', 'fixtures', 'files', file_name)
        image.file.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpg')
      end
    end
  end
end
