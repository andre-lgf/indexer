# frozen_string_literal: true

require "spec_helper"

RSpec.describe(Profiles::UpdateProfile, type: :interactor) do
  subject(:context) { described_class.call(profile:, personal_data:, organizations:) }
  let(:profile) { create(:profile) }
  let(:personal_data) do
    {}
  end
  let(:organizations) { nil }

  describe ".call" do
    context "valid info" do
      it "updates the profile" do
        expect(context).to(be_a_success)
        expect(profile.reload.username).to(eq(personal_data[:username]))
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
