# frozen_string_literal: true

module Profiles
  class Fetch
    include Interactor::Organizer

    # input: { profile: Profile instance }

    organize RetrievePage,
      ExtractInfo,
      UpdateProfile,
      ::Organizations::Fetch

    around :update_processing_status

    private

    def validate_input
      context.fail!(errors: ["Missing profile"]) unless context.profile
      # in case someone tries to run interactor passing a profile that has not been validated
      is_profile_valid = context.profile.valid?
      context.fail!(errors: ["Invalid profile: #{context.profile.errors.full_messages}"]) unless is_profile_valid
      context.profile.save! unless context.profile.persisted? # in case someone runs the interactor with Profile.new...
    end

    def update_processing_status(interactor)
      validate_input
      context.profile.in_progress!
      interactor.call
      context.profile.completed!
    rescue => e
      Rollbar.error("[Profiles::Fetch]=>#{e.context.errors}", log: e.context.errors)
      context.fail!(errors: e.context.errors)
    end
  end
end
