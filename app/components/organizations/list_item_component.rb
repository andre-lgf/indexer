# frozen_string_literal: true

module Organizations
  class ListItemComponent < ::LiveComponent
    with_collection_parameter :organization

    def initialize(organization:)
      @organization = organization
      super
    end
  end
end
