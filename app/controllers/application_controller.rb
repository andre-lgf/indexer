# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  private def query = @query ||= params[:query].presence
end
