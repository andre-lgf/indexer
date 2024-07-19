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
      classes = @profile.completed? ? "bg-green" : "bg-yellow"

      "text-white text-center text-sm rounded-full py-1 px-3 #{classes}"
    end

    def index_status = @profile.completed? ? "Indexed" : "Indexing"
  end
end
