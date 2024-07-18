# frozen_string_literal: true

module Profiles
  class ExtractInfo
    include Interactor

    before -> { context.fail!(errors: ["Missing page"]) unless context.page }

    def call
      username = context.page.css("span.p-nickname.vcard-username.d-block").text.strip
      num_followers = handle_value(context.page.css("a").find do |a|
                                     a[:href] =~ /followers/
                                   end.css("span.text-bold").text.gsub("k", "00"))
      num_following = handle_value(context.page.css("a").find do |a|
                                     a[:href] =~ /following/
                                   end.css("span.text-bold").text.gsub("k", "00"))
      location = context.page.css("ul.vcard-details li.vcard-detail").reverse.find do |li|
        li[:itemprop] == "homeLocation"
      end.text.strip
      num_stars = context.page.css("a").find { |a| a[:href] =~ /stars/ }.at_css("span.Counter").text.to_i
      last_year_contrib = context.page.css("div.js-yearly-contributions h2").text.strip.split("\n").first.to_i
      profile_image_url = context.page.at_css("img.avatar.avatar-user")[:src]

      context.personal_data = {
        username:,
        num_followers:,
        num_following:,
        location:,
        num_stars:,
        last_year_contrib:,
        profile_image_url:,
      }

      context.organizations = context.page.css("div.js-profile-editable-replace div.border-top a").select do |a|
                                a[:"data-hovercard-type"] == "organization" && a[:"aria-label"]
                              end.map do |a|
        {
          name: a[:"aria-label"],
          organization_url: "https://github.com#{a[:href]}",
          image_url: a.at_css("img")[:src],
        }
      end
    end

    private def handle_value(value)
      formatted_value = value.include?(".") ? value.gsub(".", "") : value + "0"
      formatted_value.to_i
    end
  end
end
