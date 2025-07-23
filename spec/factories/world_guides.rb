FactoryBot.define do
  factory :world_guide do
    world_name { "テストワールド" }
    country_name { "テスト国" }
    region_name { "テスト地域" }
    category { "現在" }
    association :story

    trait :with_image do
      after(:build) do |world_guide|
        unless world_guide.image.attached?
          world_guide.image.attach(
            io: File.open(Rails.root.join('spec/fixtures/files/test_image.jpeg')),
            filename: 'test_image.jpeg',
            content_type: 'image/jpeg'
          )
        end
      end
    end
  end
end
