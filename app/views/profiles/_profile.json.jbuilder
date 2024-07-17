json.extract! profile, :id, :name, :github_url, :username, :num_followers, :num_following, :num_stars, :last_year_contrib, :profile_image_url, :location, :indexing_status, :created_at, :updated_at
json.url profile_url(profile, format: :json)
