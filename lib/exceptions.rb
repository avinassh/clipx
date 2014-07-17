module Exceptions
  class ENMLValidationError < StandardError
    def initialize(msg)
      super
    end
  end
end