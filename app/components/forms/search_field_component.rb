# frozen_string_literal: true

module Forms
  class SearchFieldComponent < ::LiveComponent
    def initialize(url:, turbo_frame:, label:, placeholder:, allow_elastic: false)
      @url = url
      @turbo_frame = turbo_frame
      @label = label
      @placeholder = placeholder || I18n.t(".actions.search")
      @allow_elastic = allow_elastic
      super
    end
  end
end
