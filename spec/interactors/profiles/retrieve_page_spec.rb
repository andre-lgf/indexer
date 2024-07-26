# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Profiles::RetrievePage, type: :interactor) do
  include_context "with_url_shortener"
  include_context "with_elastic"

  subject(:context) { described_class.call(profile:) }
  describe ".call" do
    context "valid profile", vcr: true do
      let(:profile) { create(:profile, github_url: "https://github.com/matz") }

      it "fetches the profile" do
        expect(context).to(be_a_success)
        expect(context.page).to_not(be_blank)
      end
    end

    context "organization", vcr: true do
      let(:profile) { create(:profile, github_url: "https://github.com/rails") }

      it "fetches the organization and removes the profile record" do
        expect(context).to(be_a_success)
        expect(Profile.where(github_url: profile.github_url).exists?).to(be_falsey)
        expect(Organization.where(organization_url: profile.github_url).exists?).to(be_truthy)
      end
    end

    context "profiles does not exist", vcr: true do
      let(:profile) { create(:profile, github_url: "https://github.com/nao_tem") }
      it "fails" do
        expect(context).to(be_a_failure)
        expect(context.errors).to(eq(["Page not found"]))
        expect(profile.reload.error?).to(be_truthy)
      end
    end
  end
end
