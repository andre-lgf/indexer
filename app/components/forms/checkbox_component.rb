# frozen_string_literal: true

module Forms
  class CheckboxComponent < ViewComponent::Base
    def initialize(input_name:, checked: false, label: nil, object: nil, flex_direction: "flex-col-reverse", col_span: 1,
      col_span_breakpoint: "md", data: {})
      @object = object&.model_name&.singular
      @input_name = input_name
      @checked = checked
      @label = label || input_name
      @flex_direction = flex_direction
      @col_span = col_span
      @col_span_breakpoint = col_span_breakpoint
      @data = data
      super
    end

    private def custom_colspan = "#{@col_span_breakpoint}:col-span-#{@col_span}"
  end
end
