# frozen_string_literal: true

require_relative "base"

module SPSS
  class Reader < Base
    include Enumerable

    class Error < StandardError; end

    attr_reader :variables

    def initialize(filename)
      super()
      raise ArgumentError, "input file may not be nil" if filename.nil?

      @variable_handles = Hash.new { |hash, key| hash[key] = allocate_var_handle(key) }
      @variables = Hash.new { |hash, key| hash[key] = Variable.new(handle, key, variable_sizes[key]) }
      @value_labels = Hash.new { |hash, key| hash[key] = read_value_labels(key) }
      @handle = API.open_read(filename)
      return unless block_given?

      yield self
      close
    end

    def close
      API.close_read(handle)
    end

    def variable_names
      variable_sizes.keys
    end

    def numeric?(name)
      variable_sizes[name] == 0
    end

    def missing_value
      @missing_value ||= API.host_sysmis_val
    end

    def case_weight_variable
      @case_weight_variable ||= API.get_case_weight_var(handle)
    end

    def number_of_cases
      @number_of_cases ||= API.get_number_of_cases(handle)
    end
    alias size number_of_cases

    def variable_handle(name)
      @variable_handles[name]
    rescue SPSS::Error => e
      raise unless e.symbol == :var_notfound
    end

    def label(name)
      API.get_var_label(handle, name)
    end

    def values(name)
      @value_labels[name]
    end

    def value_label(name, value)
      return if value == missing_value

      values(name).fetch(value)
    end

    def fetch(name)
      sz = variable_sizes[name]
      raise Error, "No such variable #{name.inspect}" if sz.nil?

      if sz.zero?
        API.get_value_numeric(handle, variable_handle(name))
      else
        API.get_value_char(handle, variable_handle(name), sz)
      end
    end

    def each_variable
      return enum_for(:each_variable) unless block_given?

      variable_names.each do |name|
        yield variables[name]
      end
    end

    def each
      return enum_for(:each) unless block_given?

      cr = CaseRecord.new(self)
      number_of_cases.times do
        API.read_case_record(handle)
        yield cr
      end
    end

    def variable_missing_values(name)
      if variable_sizes[name].zero?
        API.get_var_n_missing_values(handle, name)
      else
        API.get_var_c_missing_values(handle, name)
      end
    end

    def variable_sizes
      @variable_sizes ||= API.get_var_names(handle).to_h
    end

    private

    class CaseRecord
      include Enumerable

      attr_reader :reader

      def initialize(reader)
        @reader = reader
      end

      def fetch(name)
        reader.fetch(name)
      end

      def [](name)
        fetch(name)
      end

      def each
        return enum_for(:each) unless block_given?

        reader.variable_names.each do |name|
          yield fetch(name)
        end
      end
    end

    def allocate_var_handle(name)
      API.get_var_handle(handle, name)
    rescue Error => e
      raise unless e.message == "var_notfound"
    end

    def read_value_labels(name)
      if numeric?(name)
        API.get_var_n_value_labels(handle, name).to_h
      else
        API.get_var_c_value_labels(handle, name).to_h
      end
    rescue Warning => e
      raise unless e.message == "no_labels"

      :no_labels
    end
  end
end
