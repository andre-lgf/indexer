# frozen_string_literal: true

require "rails_helper"

RSpec.describe("profiles/index", type: :view) do
  before(:each) do
    assign(:profiles, build_stubbed_list(:profile, 2, :filled))
  end

  it "renders a list of profiles" do
    render
    assert "turbo-frame", count: 2
  end
end
