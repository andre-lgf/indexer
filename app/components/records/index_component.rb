# frozen_string_literal: true

module Records
  class IndexComponent < ::LiveComponent
    def initialize(resource_model:, resource_icon:, collection:, new_resource_url: nil, show_title: true, title: nil,
      pagy: nil, searchable: false, search_url: nil, turbo_frame_resource_name: nil, search_placeholder: nil,
      new_resource_frame_tag: nil, list_resource_frame_tag: nil, index_frame_tag: nil)
      @resource_model = resource_model
      @resource_icon = resource_icon
      @collection = collection
      @turbo_frame_resource_name = turbo_frame_resource_name
      @list_resource_frame_tag = list_resource_frame_tag || "#{turbo_resource_name}s"
      @new_resource_frame_tag_id = new_resource_frame_tag || "new-#{turbo_resource_name}"
      @index_frame_tag_id = index_frame_tag || "#{turbo_resource_name}s-index"
      @new_resource_url = new_resource_url
      @show_title = show_title
      @title = title
      @searchable = searchable
      @pagy = pagy
      @search_url = search_url
      @search_placeholder = search_placeholder
      super
    end

    private

    def empty_collection = @empty_collection ||= @collection.empty?
    alias_method :empty_collection?, :empty_collection
    def query = @query ||= params[:query]

    def turbo_resource_name
      @turbo_resource_name ||= @turbo_frame_resource_name || @resource_model.name.underscore
    end
  end
end
