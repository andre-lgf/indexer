# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :organization_url, presence: true, uniqueness: true, url: { host: /github\.com/ }
  has_and_belongs_to_many :profiles
end
