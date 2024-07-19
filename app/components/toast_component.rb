# frozen_string_literal: true

class ToastComponent < ViewComponent::Base
  def initialize(type:, message:, fade: true)
    @type = type.to_sym
    @message = message
    @fade = fade
    super
  end
end
