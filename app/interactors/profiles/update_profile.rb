# frozen_string_literal: true

module Profiles
  class UpdateProfile
    include Interactor

    before :validate_input

    def call
      ApplicationRecord.transaction do
        # TODO: upsert organizations and associate with profile
        context.profile.update!(context.personal_data.merge(indexing_status: :completed))
      end
    end

    private def validate_input
      errors = []
      %i[profile personal_data].each { |field| errors << "Missing #{field}" unless context.send(field) }
      context.fail!(errors:) if errors.any?
    end
  end
end
