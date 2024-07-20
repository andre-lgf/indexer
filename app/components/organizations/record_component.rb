# frozen_string_literal: true

module Organizations
  class RecordComponent < ::LiveComponent
    def initialize(organization:)
      @organization = organization
      super
    end
  end
end
