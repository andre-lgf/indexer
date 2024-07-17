# frozen_string_literal: true

class Profile < ApplicationRecord
  validates_presence_of :name
  validates :github_url, presence: true, uniqueness: true, url: { host: /github\.com/ }
  enum indexing_status: { in_progress: 0, completed: 1 }
end
