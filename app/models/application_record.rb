# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  class << self
    def normalized_resource = @normalized_resource ||= name.underscore.tr("/", "_")
  end
end
