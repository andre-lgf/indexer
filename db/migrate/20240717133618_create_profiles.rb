class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :github_url
      t.string :username
      t.integer :num_followers
      t.integer :num_following
      t.integer :num_stars
      t.integer :last_year_contrib
      t.string :profile_image_url
      t.string :location
      t.integer :indexing_status

      t.timestamps
    end

    add_index :profiles, :github_url, unique: true
    add_index :profiles, :name
  end
end
