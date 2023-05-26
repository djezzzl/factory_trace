# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    trait :with_phone do
      phone { "phone" }
    end
  end

  factory :special_user, parent: :user

  factory :admin, parent: :user do
    trait :with_address
  end
end

FactoryBot.define do
  trait :with_email do
    email { "email" }
  end
end
