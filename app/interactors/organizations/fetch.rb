# frozen_string_literal: true

module Organizations
  class Fetch
    include Interactor

    ORG_FIELDS = %i[gh_id num_public_repos num_public_gists followers following num_members]

    before -> { context.fail!(errors: ["Missing profile"]) unless context.profile }

    def call
      client = Octokit::Client.new
      org_data = []
      context.profile.organizations.each do |org|
        org_name = org.organization_url.split("/").last
        org_data << Rails.cache.fetch(org_name, expires_in: 1.hour) do
          data = client.organization(org_name)
          data.to_h.slice(*ORG_FIELDS).merge!(
            name: org.name, organization_url: org.organization_url,
            image_url: data.avatar_url, gh_id: data.id,
            num_members: client.organization_members(org_name).size
          )
        end
        Organization.upsert_all(org_data, unique_by: %i[name organization_url])
      end
    end
  end
end
