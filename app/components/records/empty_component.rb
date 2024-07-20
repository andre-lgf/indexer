# frozen_string_literal: true

module Records
  class EmptyComponent < ::LiveComponent
    def initialize(icon:, resource:, frame_tag:, info: nil, url: nil, icon_color: "text-green",
      icon_background_color: "bg-green-light", render: true, show_title: false, read_only: false)
      @icon = icon
      @resource = resource
      @frame_tag = frame_tag
      @info = info
      @url = url
      @icon_color = icon_color
      @icon_background_color = icon_background_color
      @render = render
      @read_only = read_only
      super
    end

    private

    def render? = @render
    def normalized_resource = @normalized_resource ||= @resource.normalized_resource
    def translated_resource = @translated_resource ||= @resource.translated_resource
    def new_resource_url = @url || new_polymorphic_path(@resource)
    def info = @info || "No #{normalized_resource} found."
  end
end
