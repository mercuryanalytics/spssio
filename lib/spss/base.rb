# frozen_string_literal: true

require_relative "api"

module SPSS
  class Base
    attr_reader :handle

    def compression
      result = API.get_compression(handle)
      case result
      when 0
        :none
      when 1
        :standard
      when 2
        :zlib
      else
        result
      end
    end

    def compression=(value)
      value = case value
              when nil, :none
                0
              when :standard
                1
              when :zsav
                2
              end
      API.set_compression(handle, value)
    end
  end
end
