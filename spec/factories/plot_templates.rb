FactoryBot.define do
  factory :plot_template do
    sequence(:name) { |n| "テストテンプレート#{n}" }
    sequence(:body) { |n| "これはテストテンプレート#{n}の内容です。\n" }
    description { nil }
  end
end
