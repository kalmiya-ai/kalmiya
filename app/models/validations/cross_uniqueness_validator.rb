# frozen_string_literal: true

module Validations
  # Validate uniqueness of values in one column against a different column.
  class CrossUniquenessValidator < ActiveRecord::Validations::UniquenessValidator
    def validate_each(record, _attribute, value)
      super(record, options[:against], value)
    end
  end
end
