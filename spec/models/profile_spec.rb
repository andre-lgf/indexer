# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Profile, type: :model) do
  context "validations" do
    it "requires both name and github url" do
      expect(described_class.new.valid?).to(be_falsey)
      expect(described_class.new(name: Faker::Name.name).valid?).to(be_falsey)
      expect(described_class.new(github_url: Faker::Internet.url).valid?).to(be_falsey)
      expect(described_class.new(
        name: Faker::Name.name,
        github_url: Faker::Internet.url(host: "github.com"),
      ).valid?).to(be_truthy)
    end

    it "requires github url to be a url" do
      profile = described_class.new(github_url: "something other than a url")
      expect(profile.valid?).to(be_falsey)
      expect(profile.errors.full_messages).to(include("Github url is invalid"))
    end

    it "requires github url to have github as host" do
      profile = described_class.new(github_url: Faker::Internet.url)
      expect(profile.valid?).to(be_falsey)
      expect(profile.errors.full_messages).to(include("Github url has invalid host"))
    end
  end
end
