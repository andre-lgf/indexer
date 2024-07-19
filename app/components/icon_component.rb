# frozen_string_literal: true

class IconComponent < ViewComponent::Base
  DEFAULT_ICON_CLASS = "rounded-full object-cover flex justify-center items-center px-5 py-5"

  def initialize(icon:, size: "text-2xl", color: "text-red", custom_class: nil, append_class: false,
    background_color: "bg-gray-light")
    @icon = icon
    @size = size
    @color = color
    @custom_class = custom_class
    @append_class = append_class
    @background_color = background_color
    super
  end

  private

  def icon_class = "#{DEFAULT_ICON_CLASS} #{@background_color} #{@custom_class}"
  def default_icon = "ti ti-#{@icon}"
  def icon = "#{default_icon} #{@size} #{@color}"
end
