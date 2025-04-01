# frozen_string_literal: true

require_relative "variable"

# module SPSS
#   class Writer < Base
#     def initialize(filename)
#       @handle = API.open_write(filename)
#       # @variable_handles = Hash.new { |hash, key| hash[key] = allocate_var_handle(key) }
#     end

#     def close
#       API.close_write(handle)
#     end

#     def define_variable(name, options = {})
#       API.set_var_name(@handle, name, 0)
#       API.set_var_label(@handle, name, options[:label]) if options.key?(:label)
#       # return unless options.key?(:categories)
#     end
#   end
# end

module SPSS
  class Writer
    attr_reader :handle
    attr_reader :variables

    def initialize(filename)
      @handle = API.open_write(filename)
      @variables = Hash.new { |hash, key| hash[key] = Variable.new(handle, key) }
      return unless block_given?

      yield self
      close
    end

    def number_of_cases
      @number_of_cases ||= API.get_number_of_cases(handle)
    end
    alias size number_of_cases

    def close
      API.close_write(handle)
    end

    def create_variable(name, size: 0)
      API.set_var_name(handle, name, size)
      yield variables[name] if block_given?
    end

    def commit_header
      API.commit_header(handle)
    end

    def commit_case_record
      API.commit_case_record(handle)
    end
  end
end
