# frozen_string_literal: true

require "rails_helper"

RSpec.describe("profiles/show", type: :view) do
  before(:each) { assign(:profile, build_stubbed(:profile, :filled)) }

  it "renders component" do
    render
    expect(rendered).to(match(/turbo-frame/))
  end
end
