# frozen_string_literal: true

module Dropdown
  class ItemComponent < ViewComponent::Base
    def initialize(title:, icon:, url:, data: {}, icon_class: "text-green", destroy: false, post: false, put: false,
      target: nil)
      @title = title
      @icon = icon
      @url = url
      @data = data
      @icon_class = icon_class
      @destroy = destroy
      @post = post
      @put = put
      @target = target
      super
    end

    private def full_icon_class = "ti ti-#{@icon} mr-3 text-2xl #{@icon_class}"
  end
end
