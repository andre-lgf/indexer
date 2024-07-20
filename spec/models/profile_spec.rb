# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Profile, type: :model) do
  include_context "with_url_shortener"
  include_context "with_elastic"

  around(:each) do |example|
    I18n.with_locale(:en) { example.run }
  end

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

  context "callbacks" do
    context "when updating github url" do
      let(:profile) { create(:profile) }
      it "fetches profile" do
        allow(FetchProfileJob).to(receive(:perform_async)).with(profile.id)
        profile.update(github_url: Faker::Internet.url(host: "github.com"))
        expect(FetchProfileJob).to(have_received(:perform_async).with(profile.id))
      end
    end

    context "error shortening url" do
      let(:profile) { create(:profile) }
      it "fails to update" do
        allow(UrlShortener).to(receive(:call).and_return(double(success?: false, errors: double(["Error details"]))))
        expect do
          profile.update(github_url: Faker::Internet.url(host: "github.com"))
        end.to(raise_error(ActiveModel::StrictValidationFailed))
      end
    end

    context "when saving" do
      let(:profile) { create(:profile) }
      it "reindexes profile into Elasticsearch" do
        profile.update(name: "Some name")
        expect(profile).to(have_received(:reindex).at_least(:once))
      end
    end
  end
end
