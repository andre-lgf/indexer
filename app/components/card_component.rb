# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(footer: nil, custom_class: nil)
    @footer = footer
    @custom_class = custom_class
    super
  end
end
