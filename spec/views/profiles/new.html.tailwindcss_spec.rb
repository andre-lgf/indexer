# frozen_string_literal: true

require "rails_helper"

RSpec.describe("profiles/new", type: :view) do
  before(:each) { assign(:profile, build(:profile)) }

  it "renders new profile form" do
    render

    assert_select "form[action=?][method=?]", profiles_path, "post" do
      assert_select "input[name=?]", "profile[name]"

      assert_select "input[name=?]", "profile[github_url]"
    end
  end
end
