# frozen_string_literal: true

require "rails_helper"
require "sidekiq/testing"

RSpec.describe(FetchProfileJob, type: :job) do
  include_context "with_url_shortener"

  let(:profile) { create(:profile, github_url: "https://github.com/matz", name: "Matz") }

  it "runs" do
    expect do
      described_class.perform_async(profile.id)
    end.to(change(described_class.jobs, :size).by(1))
  end

  it "fetches and updates the profile" do
    allow(Profiles::Fetch).to(receive(:call))

    Sidekiq::Testing.inline! do
      described_class.perform_async(profile.id)
      expect(Profiles::Fetch).to(have_received(:call))
    end
  end
end
