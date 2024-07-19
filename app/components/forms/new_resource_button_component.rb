# frozen_string_literal: true

module Forms
  class NewResourceButtonComponent < ViewComponent::Base
    def initialize(url:, resource_name:)
      @url = url
      @resource_name = resource_name
      super
    end
  end
end
