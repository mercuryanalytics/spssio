# frozen_string_literal: true

module SPSS
  class Variable
    attr_reader :handle
    attr_reader :name

    def initialize(handle, name, type)
      @handle = handle
      @name = name
      @type = type
    end

    def numeric?
      @type.zero?
    end

    def sort_indicator(value)
      value = value.to_i if (value - value.floor).zero?
      "_#{value.to_s.rjust(Math.log10(value_labels.keys.max).floor + 1, '0')}"
    end

    def label_for(value)
      value_labels[value]
    end

    def presentation(value)
      return value unless numeric?
      return nil if value == API.sysmis_val

      "_#{sort_indicator(value)}/#{label_for(value)}"
    rescue Warning => e
      raise unless e.symbol == :no_labels

      value = value.to_i if (value - value.floor).zero?
      value
    end

    def alignment
      API.get_var_alignment(handle, name)
    end

    def alignment=(value)
      API.set_var_alignment(handle, name, value)
    end

    def attributes
      API.get_var_attributes(handle, name)
    end

    def attributes=(value)
      API.set_var_attributes(handle, name, value)
    end

    def column_width
      API.get_var_column_width(handle, name)
    end

    def column_width=(value)
      API.set_var_column_width(handle, name, value)
    end

    def label
      API.get_var_label(handle, name)
    rescue Warning => e
      raise unless e.symbol == :no_label
    end

    def label=(value)
      API.set_var_label(handle, name, value)
    end

    def measure_level
      API.get_var_measure_level(handle, name)
      # one of SPSS_MLVL_NOM, SPSS_MLVL_ORD, or SPSS_MLVL_RAT
    end

    def measure_level=(value)
      API.set_var_measure_level(handle, name, value)
    end

    def role
      API.get_var_role(handle, name)
    end

    def role=(value)
      API.set_var_role(handle, name, value)
    end

    def value_labels
      @value_labels ||= API.get_var_n_value_labels(handle, name).to_h
    end

    def value_labels=(values)
      # TODO: figure out how to handle c_value_labels, if they turn up
      API.set_var_n_value_labels(handle, [name], values)
    end

    def numeric_value
      API.get_value_numeric(handle, vhandle)
    end

    def numeric_value=(value)
      API.set_value_numeric(handle, vhandle, value)
    end

    def char_value(size)
      API.get_value_char(handle, vhandle, size)
    end

    def char_value=(value)
      API.set_value_char(handle, vhandle, value)
    end

    def print_format
      API.get_var_print_format(handle, name)
    end

    def set_print_format(type, dec, width)
      # [print_type.read_int, print_dec.read_int, print_wid.read_int]
      API.set_var_print_format(handle, name, type, dec, width)
    end

    # TODO: writer for this
    def write_format
      API.get_var_write_format(handle, name)
    end

    def vhandle
      @vhandle ||= API.get_var_handle(handle, name)
    end
  end
end
