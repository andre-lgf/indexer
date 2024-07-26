# frozen_string_literal: true

require "open-uri"
require "watir"

module Profiles
  class RetrievePage
    include Interactor

    def call
      browser = Watir::Browser.new(:firefox, headless: true, service: { port: "9999" })
      browser.goto(context.profile.github_url)
      if browser.title =~ /Page not found/
        context.profile.error!
        context.fail!(errors: ["Page not found"])
      end
      page = Nokogiri::HTML.parse(browser.html)
      if page.at_css("main div")&.attribute_nodes&.find { |an| an.name.eql?("itemtype") }&.value =~ /Organization/
        context.profile.organizations << Organization.find_or_create_by(
          name: context.profile.name,
          organization_url: context.profile.github_url,
        ) do |org|
          org.image_url = page.at_css("img.avatar")[:src]
        end
        ::Organizations::Fetch.call(profile: context.profile)
        context.profile.destroy
      else
        browser.wait_until { browser.element(css: "div.js-yearly-contributions").exists? } # wait for turbo-frame
        context.page = Nokogiri::HTML.parse(browser.html)
        browser.close
      end
    rescue => e
      errors, message = if e.instance_of?(Interactor::Failure)
        [
          e.context.errors,
          e.context.errors,
        ]
      else
        [[e.message], e.backtrace]
      end
      Rollbar.error("[Profiles::Fetch]=>#{errors}", log: message)
      context.profile.error!
      context.fail!(errors: errors)
    end
  end
end
