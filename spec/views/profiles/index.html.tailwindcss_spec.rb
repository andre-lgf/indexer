# frozen_string_literal: true

require "rails_helper"

RSpec.describe("profiles/index", type: :view) do
  before(:each) do
    assign(:profiles, build_stubbed_list(:profile, 2, :filled))
  end

  it "renders a list of profiles" do
    render
    cell_selector = "div>p"
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("http://".to_s), count: 4 # each record has 2 urls (profile and image)
    assert_select cell_selector, text: Regexp.new("Username".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(:completed.to_s), count: 2
  end
end
