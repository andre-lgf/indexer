# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_17_133618) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "profiles", force: :cascade do |t|
    t.string "name", null: false
    t.string "github_url", null: false
    t.string "username"
    t.integer "num_followers"
    t.integer "num_following"
    t.integer "num_stars"
    t.integer "last_year_contrib"
    t.string "profile_image_url"
    t.string "location"
    t.integer "indexing_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_url"], name: "index_profiles_on_github_url", unique: true
    t.index ["name"], name: "index_profiles_on_name"
  end

end
