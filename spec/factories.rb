# frozen_string_literal: true

class User
  attr_accessor :name, :phone, :email, :address
end

class Company
  attr_accessor :address, :manager
end

class Article
end

class Comment
  attr_accessor :article
end

class Task
  attr_accessor :status
end

FactoryBot.define do
  factory :user do
    name { "name" }

    trait :with_phone do
      phone { "phone" }
    end

    factory :user_with_defaults, traits: %i[with_address with_phone]
  end

  factory :admin, parent: :user do
    trait :with_email do
      email { "email" }
    end

    trait :combination do
      with_email
      with_phone
    end
  end

  factory :manager, parent: :admin do
    with_phone
  end

  factory :company do
    trait :with_manager do
      manager
    end
  end

  factory :article, aliases: %i[post]

  factory :comment do
    post
  end

  trait :with_address do
    address { "address" }
  end

  factory :task do
    FactoryBot::VERSION >= "6.0.0" ? traits_for_enum(:status, {queued: 0, started: 1, finished: 2}) : trait(:queued) { status { 0 } } && trait(:started) { status { 1 } } && trait(:finished) { status { 2 } }
  end
end
