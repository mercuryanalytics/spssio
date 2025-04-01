# frozen_string_literal: true

module SPSS
  class Variable
    attr_reader :handle
    attr_reader :name

    def initialize(handle, name)
      @handle = handle
      @name = name
    end

    def alignment(name)
      API.get_var_alignment(handle, name)
    end

    def alignment=(value)
      API.set_var_alignment(handle, name, value)
    end

    def attributes(name)
      API.get_var_attributes(handle, name)
    end

    def attributes=(value)
      API.set_var_attributes(handle, name, value)
    end

    def column_width(name)
      API.get_var_column_width(handle, name)
    end

    def column_width=(value)
      API.set_var_column_width(handle, name, value)
    end

    def label(name)
      API.get_var_label(handle, name)
    end

    def label=(value)
      API.set_var_label(handle, name, value)
    end

    def measure_level(name)
      API.get_var_measure_level(handle, name)
    end

    def measure_level=(value)
      API.set_var_measure_level(handle, name, value)
    end

    def role(name)
      API.get_var_role(handle, name)
    end

    def role=(value)
      API.set_var_role(handle, name, value)
    end

    # TODO: reader for this
    def value_labels=(values)
      return if values == :no_labels

      # TODO: figure out how to handle c_value_labels, if they turn up
      API.set_var_n_value_labels(handle, [name], values)
    end

    def numeric_value=(value)
      API.set_value_numeric(handle, vhandle, value)
    end

    def char_value=(value)
      API.set_value_char(handle, vhandle, value)
    end

    def print_format(name)
      API.get_var_print_format(handle, name)
    end

    def set_print_format(type, dec, width)
      # [print_type.read_int, print_dec.read_int, print_wid.read_int]
      API.set_var_print_format(handle, name, type, dec, width)
    end

    # TODO: writer for this
    def write_format(name)
      API.get_var_write_format(handle, name)
    end

    def vhandle
      @vhandle ||= API.get_var_handle(handle, name)
    end
  end
end
