# frozen_string_literal: true

class PaginationComponent < LiveComponent
  include Pagy::Frontend

  attr_reader :pagy

  def initialize(pagy:)
    @pagy = pagy
    super
  end
end
