# frozen_string_literal: true

require 'spssio/base'

module SPSS
  class Writer < Base
    def initialize(filename)
      @handle = API.open_write(filename)
      @variable_handles = Hash.new { |hash, key| hash[key] = allocate_var_handle(key) }
    end

    def close
      API.close_write(handle)
    end

    def define_variable(name, options = {})
    end
  end
end
