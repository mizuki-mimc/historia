FactoryBot.define do
  factory :character do
    name { "テストキャラクター" }
    race { "人間" }
    gender { :male }
    age { "20歳" }
    category { "現在" }
    association :story

    trait :with_image do
      after(:build) do |character|
        unless character.image.attached?
          character.image.attach(
            io: File.open(Rails.root.join('spec/fixtures/files/test_image.jpeg')),
            filename: 'test_image.jpeg',
            content_type: 'image/jpeg'
          )
        end
      end
    end
  end
end
