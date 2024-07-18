# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Profiles::UpdateProfile, type: :interactor) do
  include_context "with_url_shortener"

  subject(:context) { described_class.call(profile:, personal_data:, organizations:) }
  let(:profile) { create(:profile) }
  let(:personal_data) do
    {
      username: Faker::Internet.username,
      num_followers: 1,
      num_following: 1,
      num_stars: 1,
      last_year_contrib: 1,
      profile_image_url: Faker::Internet.url,
      location: Faker::Address.full_address,
    }
  end
  let(:organizations) do
    [
      {
        name: "mruby",
        organization_url: "https://github.com/mruby",
        image_url: "https://avatars.githubusercontent.com/u/1796512?s=64&v=4",
      },
      {
        name: "mrbgems",
        organization_url: "https://github.com/mrbgems",
        image_url: "https://avatars.githubusercontent.com/u/24491080?s=64&v=4",
      },
    ]
  end

  describe ".call" do
    context "valid info" do
      context "with organizations" do
        it "updates the profile and assign organizations" do
          expect(context).to(be_a_success)
          expect(profile.reload.username).to(eq(personal_data[:username]))
          expect(profile.organizations.pluck(:name)).to(match_array(organizations.map { |o| o[:name] }))
        end
      end

      context "without organizations" do
        let(:organizations) { nil }

        it "updates the profile" do
          expect(context).to(be_a_success)
          expect(profile.reload.username).to(eq(personal_data[:username]))
          expect(profile.organizations.none?).to(be_truthy)
        end
      end
    end

    context "missing info" do
      let(:profile) { nil }
      let(:personal_data) { nil }

      it "fails" do
        expect(context).to(be_a_failure)
        expect(context.errors).to(match_array(["Missing profile", "Missing personal_data"]))
      end
    end
  end
end
