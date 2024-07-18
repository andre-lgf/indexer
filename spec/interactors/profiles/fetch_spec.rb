# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Profiles::Fetch, type: :interactor) do
  subject(:context) { described_class.call(profile:) }
  let(:profile) { create(:profile, github_url: "https://github.com/matz") }

  describe ".call" do
    context "valid profile" do
      before do
        allow(profile).to(receive(:in_progress!))
        allow(profile).to(receive(:completed!))
      end

      context "persisted profile" do
        it "calls interactors" do
          [
            Profiles::RetrievePage,
            Profiles::ExtractInfo,
            Profiles::UpdateProfile,
          ].each do |interactor|
            expect(interactor).to(receive(:call!).ordered)
          end
          context
          expect(profile).to(have_received(:in_progress!).once)
          expect(profile).to(have_received(:completed!).once)
        end

        it "fetches the profile", vcr: true do
          expect(context).to(be_a_success)
        end
      end

      context "unpersisted profile" do
        let(:profile) { build(:profile) }
        it "saves profile and calls interactors" do
          [
            Profiles::RetrievePage,
            Profiles::ExtractInfo,
            Profiles::UpdateProfile,
          ].each do |interactor|
            expect(interactor).to(receive(:call!).ordered)
          end
          context
          expect(profile.persisted?).to(be_truthy)
          expect(profile).to(have_received(:in_progress!).once)
          expect(profile).to(have_received(:completed!).once)
        end
      end
    end

    context "missing profile" do
      let(:profile) { nil }
      it "fails" do
        expect(context).to(be_a_failure)
        expect(context.errors).to(eq(["Missing profile"]))
      end
    end

    context "invalid profile" do
      let(:profile) { build(:profile, github_url: "invalid url") }
      it "fails" do
        expect(context).to(be_a_failure)
        expect(context.errors).to(match(["Invalid profile: [\"Github url is invalid\"]"]))
      end
    end

    context "unexisting profile", vcr: true do
      let(:profile) { build(:profile, github_url: "https://github.com/some-unexisting-user") }
      it "fails" do
        expect(context).to(be_a_failure)
      end
    end
  end
end
