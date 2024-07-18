# frozen_string_literal: true

class Profile < ApplicationRecord
  validates_presence_of :name
  validates :github_url, presence: true, uniqueness: true, url: { host: /github\.com/ }
  after_update :fetch_profile, if: :saved_change_to_github_url?
  enum indexing_status: { in_progress: 0, completed: 1 }

  private def fetch_profile = Profiles::Fetch.call(profile: self)
end
