FactoryBot.define do
  factory :user do
    username { FFaker::Internet.unique.user_name }
    password { FFaker::Internet.password }
  end
end
