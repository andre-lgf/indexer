# frozen_string_literal: true

module Cards
  class SectionComponent < ViewComponent::Base
    def initialize(title: nil, subtitle: nil, should_render: true)
      @title = title
      @subtitle = subtitle
      @should_render = should_render
      super
    end

    def render? = @should_render
  end
end
