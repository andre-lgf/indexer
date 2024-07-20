# frozen_string_literal: true

RSpec.shared_context("with_organizations_fetch") do
  around do |example|
    VCR.use_cassette("fetch_organization") do
      example.run
    end
  end
end
