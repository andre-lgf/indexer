# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    name { Faker::Name.name }
    github_url { Faker::Internet.url(host: "github.com") }

    trait :filled do
      username { Faker::Internet.username }
      num_followers { 1 }
      num_following { 1 }
      num_stars { 1 }
      last_year_contrib { 1 }
      profile_image_url { Faker::Internet.url }
      location { Faker::Address.full_address }
      indexing_status { :completed }
      shortened_url { Faker::Internet.url(host: "tinyurl.com") }
    end
  end
end
