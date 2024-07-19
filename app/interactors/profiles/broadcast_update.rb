# frozen_string_literal: true

module Profiles
  class BroadcastUpdate
    include Interactor, Turbo::Streams::Broadcasts, Turbo::Streams::StreamName

    before -> { context.fail!(errors: ["Missing profile"]) unless context.profile }

    def call
      broadcast_update_to(
        "profile_#{context.profile.id}-full",
        html: ::Profiles::RecordComponent.new(profile: context.profile).render_in(ViewContextHelper::Delegator.new),
      )
      broadcast_update_to(
        "profile_#{context.profile.id}",
        html: ::Profiles::ListItemComponent.new(profile: context.profile).render_in(ViewContextHelper::Delegator.new),
      )
    end
  end
end
