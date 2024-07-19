# frozen_string_literal: true

module Dropdown
  class ActionsComponent < ViewComponent::Base
    def initialize(resource:, show: true, edit: true, delete: true, prepend_items: false)
      @resource = resource
      @show = show
      @edit = edit
      @delete = delete
      @prepend_items = prepend_items
      super
    end

    private

    def resource_show_path = polymorphic_path(@resource)
    def resource_edit_path = edit_polymorphic_path(@resource)
  end
end
