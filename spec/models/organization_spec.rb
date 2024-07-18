# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Organization, type: :model) do
  context "validations" do
    it "requires both name and organization url" do
      expect(described_class.new.valid?).to(be_falsey)
      expect(described_class.new(name: Faker::Name.name).valid?).to(be_falsey)
      expect(described_class.new(organization_url: Faker::Internet.url).valid?).to(be_falsey)
      expect(described_class.new(
        name: Faker::Name.name,
        organization_url: Faker::Internet.url(host: "github.com"),
      ).valid?).to(be_truthy)
    end

    it "requires organization url to be a url" do
      organization = described_class.new(organization_url: "something other than a url")
      expect(organization.valid?).to(be_falsey)
      expect(organization.errors.full_messages).to(include("Organization url is invalid"))
    end

    it "requires organization url to have github as host" do
      organization = described_class.new(organization_url: Faker::Internet.url)
      expect(organization.valid?).to(be_falsey)
      expect(organization.errors.full_messages).to(include("Organization url has invalid host"))
    end
  end
end
