# frozen_string_literal: true

module Profiles
  class RecordComponent < ::LiveComponent
    def initialize(profile:)
      @profile = profile
      super
    end
  end
end
