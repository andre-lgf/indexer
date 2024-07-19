# frozen_string_literal: true

require "rails_helper"

RSpec.describe("profiles/edit", type: :view) do
  let(:profile) { build_stubbed(:profile) }

  before(:each) { assign(:profile, profile) }

  it "renders the edit profile form" do
    render

    assert_select "form[action=?][method=?]", profile_path(profile), "post" do
      assert_select "input[name=?]", "profile[name]"

      assert_select "input[name=?]", "profile[github_url]"
    end
  end
end
