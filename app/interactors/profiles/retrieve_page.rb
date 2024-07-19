# frozen_string_literal: true

require "open-uri"
require "watir"

module Profiles
  class RetrievePage
    include Interactor

    def call
      browser = Watir::Browser.new(:firefox, headless: true, service: { port: "9999" })
      browser.goto(context.profile.github_url)
      browser.wait_until { browser.element(css: "div.js-yearly-contributions").exists? } # wait for turbo-frame
      context.page = Nokogiri::HTML.parse(browser.html)
      browser.close
    rescue => e
      Rollbar.error("[Profiles::Fetch]=>#{e.message}", log: e.backtrace)
      context.fail!(errors: [e.message])
    end
  end
end
