# frozen_string_literal: true

module Profiles
  class ListItemComponent < ::LiveComponent
    with_collection_parameter :profile

    def initialize(profile:)
      @profile = profile
      super
    end

    private

    def status_class
      classes = case @profile.indexing_status.to_sym
      when :completed then "bg-green"
      when :error then "bg-red"
      else "bg-yellow"
      end

      "text-white text-center text-sm rounded-full py-1 px-3 #{classes}"
    end

    def index_status
      case @profile.indexing_status.to_sym
      when :completed then I18n.t("status.profile.indexed")
      when :error then I18n.t("status.profile.error")
      else I18n.t("status.profile.indexing")
      end
    end
  end
end
