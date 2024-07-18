# frozen_string_literal: true

require "rails_helper"

RSpec.describe(UrlShortener, type: :interactor) do
  subject(:context) { described_class.call(url:) }
  let(:url) { "https://github.com" }

  describe ".call" do
    context "url is present" do
      it "shortens the url" do
        VCR.use_cassette("url_shortener", match_requests_on: %i[method uri_ignoring_query_params]) do
          expect(context).to(be_a_success)
          expect(context.response.code).to(be(200))
          expect(context.response.body).to(match(%r{^https://tinyurl\.com/}))
        end
      end
    end

    context "missing url" do
      let(:url) { nil }
      it "fails" do
        expect(context).to(be_a_failure)
        expect(context.errors).to(eq(["Missing URL"]))
      end
    end
  end
end
