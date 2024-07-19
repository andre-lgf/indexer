# frozen_string_literal: true

module Forms
  class SearchFieldComponent < ::LiveComponent
    def initialize(url:, turbo_frame:, label:, placeholder:)
      @url = url
      @turbo_frame = turbo_frame
      @label = label
      @placeholder = placeholder || "Search"
      super
    end
  end
end
