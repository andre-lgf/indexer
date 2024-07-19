# frozen_string_literal: true

module ViewContextHelper
  class Delegator
    RouteHelpers = Module.new { delegate_missing_to "Rails.application.routes.url_helpers" }
    HELPERS = ApplicationController.helpers.extend(RouteHelpers)
    delegate_missing_to(:HELPERS)

    def protect_against_forgery? = false
  end
end
