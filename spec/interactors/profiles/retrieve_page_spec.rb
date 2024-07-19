# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Profiles::RetrievePage, type: :interactor, vcr: true) do
  include_context "with_url_shortener"
  include_context "with_elastic"

  subject(:context) { described_class.call(profile:) }
  describe ".call" do
    context "valid profile" do
      let(:profile) { create(:profile, github_url: "https://github.com/matz") }

      it "fetches the profile" do
        expect(context).to(be_a_success)
        expect(context.page).to_not(be_blank)
      end
    end
  end
end
