# frozen_string_literal: true

RSpec.shared_context("with_elastic") do
  before { allow_any_instance_of(Profile).to(receive(:reindex).and_return(true)) }
end
