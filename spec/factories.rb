class User
  attr_accessor :name, :phone, :email, :address
end

class Company
  attr_accessor :address
end

class Article
end

class Comment
  attr_accessor :article
end

FactoryBot.define do
  factory :user do
    name { 'name' }

    trait :with_phone do
      phone { 'phone' }
    end
  end

  factory :admin, parent: :user do
    trait :with_email do
      email { 'email' }
    end
  end

  factory :company

  factory :article, aliases: %i[post]

  factory :comment do
    post
  end

  trait :with_address do
    address { 'address' }
  end
end
