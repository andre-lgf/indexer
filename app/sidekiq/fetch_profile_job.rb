# frozen_string_literal: true

class FetchProfileJob
  include Sidekiq::Job

  def perform(profile_id)
    profile = Profile.find(profile_id)
    ::Profiles::Fetch.call(profile:)
  end
end
