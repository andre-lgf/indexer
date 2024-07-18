# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }
    organization_url { Faker::Internet.url(host: "github.com") }
    image_url { Faker::Internet.url }
  end
end
