# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Profiles::ExtractInfo, type: :interactor) do
  subject(:context) { described_class.call(page:) }
  let(:page) { Nokogiri.parse(build(:github_request).content) }
  describe ".call" do
    context "page provided" do
      it "extracts the personal data" do
        expect(context).to(be_a_success)
        expect(context.personal_data).to_not(be_blank)
      end
    end

    context "missing page" do
      let(:page) { nil }
      it "fails" do
        expect(context).to(be_a_failure)
        expect(context.errors).to(eq(["Missing page"]))
      end
    end
  end
end
