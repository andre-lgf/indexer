# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  class << self
    def normalized_resource = @normalized_resource ||= name.underscore.tr("/", "_")
    def translated_resource = @translated_resource ||= I18n.t("models.#{normalized_resource}")
  end
end
