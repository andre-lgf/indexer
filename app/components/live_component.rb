# frozen_string_literal: true

class LiveComponent < ViewComponent::Base
  include Turbo::Streams::Broadcasts
  include Turbo::Streams::StreamName
  include Turbo::FramesHelper
end
