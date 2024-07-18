# frozen_string_literal: true

require "rails_helper"

RSpec.describe("profiles/show", type: :view) do
  before(:each) { assign(:profile, build_stubbed(:profile, :filled)) }

  it "renders attributes in <p>" do
    render
    expect(rendered).to(match(/Name/))
    expect(rendered).to(match(%r{http\://}))
    expect(rendered).to(match(/Username/))
    expect(rendered).to(match(/2/))
    expect(rendered).to(match(/3/))
    expect(rendered).to(match(/4/))
    expect(rendered).to(match(/5/))
    expect(rendered).to(match(%r{http\://}))
    expect(rendered).to(match(/Location/))
    expect(rendered).to(match(/completed/))
  end
end
