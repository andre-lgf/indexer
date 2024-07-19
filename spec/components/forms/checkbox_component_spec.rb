# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Forms::CheckboxComponent, type: :component) do
  context "with an object" do
    it "renders checkbox with object as root for param" do
      expect(
        render_inline(described_class.new(object: build(:profile), input_name: :name)).css("input").to_html,
      ).to(include("<input name=\"profile[name]\""))
    end
  end
  context "without object" do
    it "renders checkbox with param as root" do
      expect(
        render_inline(described_class.new(object: nil, input_name: :name)).css("input").to_html,
      ).to(include("<input name=\"name\""))
    end
  end
end
