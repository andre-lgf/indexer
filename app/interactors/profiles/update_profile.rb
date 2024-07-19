# frozen_string_literal: true

module Profiles
  class UpdateProfile
    include Interactor

    before :validate_input

    def call
      ApplicationRecord.transaction do
        context.profile.update!(context.personal_data.merge(indexing_status: :completed))
        return if context.organizations.blank?

        org_ids = Organization.upsert_all(context.organizations, unique_by: %i[name organization_url], returning: :id)
        context.profile.organization_ids = org_ids.rows.flatten
      end
    end

    private def validate_input
      errors = []
      %i[profile personal_data].each { |field| errors << "Missing #{field}" unless context.send(field) }
      context.fail!(errors:) if errors.any?
    end
  end
end
