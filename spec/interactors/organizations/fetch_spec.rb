# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Organizations::Fetch, type: :interactor) do
  include_context "with_url_shortener"
  include_context "with_elastic"

  subject(:context) { described_class.call(profile:) }

  describe ".call" do
    context "valid parameters" do
      let(:profile) do
        create(:profile, organizations: [
          create(:organization, name: "mruby", organization_url: "https://github.com/mruby"),
        ])
      end
      it "fetches the organization info" do
        VCR.use_cassette("fetch_organization") do
          expect(context).to(be_a_success)
          expect(profile.organizations.first.reload.gh_id).to(eq(1796512))
        end
      end

      context "profile without organizations" do
        let(:profile) { create(:profile) }

        it "does nothing" do
          expect(context).to(be_a_success)
        end
      end
    end

    context "missing parameters" do
      let(:profile) { nil }

      it "fails" do
        expect(context).to(be_a_failure)
        expect(context.errors).to(eq(["Missing profile"]))
      end
    end
  end
end
