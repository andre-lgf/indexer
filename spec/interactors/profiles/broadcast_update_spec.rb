# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Profiles::BroadcastUpdate, type: :interactor) do
  include_context "with_url_shortener"
  include_context "with_elastic"

  subject(:context) { described_class.call(profile:) }
  let(:profile) { create(:profile) }

  describe ".call" do
    context "valid info" do
      it "broadcasts the update" do
        expect(context).to(be_a_success)
      end
    end

    context "missing info" do
      let(:profile) { nil }

      it "fails" do
        expect(context).to(be_a_failure)
        expect(context.errors).to(match_array(["Missing profile"]))
      end
    end
  end
end
