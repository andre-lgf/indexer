# frozen_string_literal: true

RSpec.shared_context("with_url_shortener") do
  before do
    allow(UrlShortener).to(receive(:call).and_return(double(
      success?: true,
      response: double(body: Faker::Internet.url(host: "tinyurl.com")),
    )))
  end
end
