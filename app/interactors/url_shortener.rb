# frozen_string_literal: true

class UrlShortener
  include Interactor

  before -> { context.fail!(errors: ["Missing URL"]) if context.url.blank? }

  def call
    context.response = RestClient.get("http://tinyurl.com/api-create.php", { params: { url: context.url } })
  end
end
