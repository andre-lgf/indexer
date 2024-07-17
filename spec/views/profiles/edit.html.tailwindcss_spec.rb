require 'rails_helper'

RSpec.describe 'profiles/edit', type: :view do
  let(:profile) { build_stubbed(:profile) }

  before(:each) { assign(:profile, profile) }

  it 'renders the edit profile form' do
    render

    assert_select 'form[action=?][method=?]', profile_path(profile), 'post' do
      assert_select 'input[name=?]', 'profile[name]'

      assert_select 'input[name=?]', 'profile[github_url]'

      assert_select 'input[name=?]', 'profile[username]'

      assert_select 'input[name=?]', 'profile[num_followers]'

      assert_select 'input[name=?]', 'profile[num_following]'

      assert_select 'input[name=?]', 'profile[num_stars]'

      assert_select 'input[name=?]', 'profile[last_year_contrib]'

      assert_select 'input[name=?]', 'profile[profile_image_url]'

      assert_select 'input[name=?]', 'profile[location]'

      assert_select 'input[name=?]', 'profile[indexing_status]'
    end
  end
end
