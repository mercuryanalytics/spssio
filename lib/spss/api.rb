# frozen_string_literal: true

require "spss/libspssdio"
require "spss/status"

module SPSS
  module IO
    # rubocop:disable Naming/AccessorMethodName, Naming/PredicateName

    def add_file_attribute(handle, attrib_name, attrib_sub, attrib_text)
      check! LIBSPSSDIO.spssAddFileAttribute(handle, attrib_name, attrib_sub, attrib_text)
    end

    def add_mult_resp_def_c(handle, mr_set_name, mr_set_label, is_dichotomy, counted_value, var_names, num_vars)
      check! LIBSPSSDIO.spssAddMultRespDefC(handle, mr_set_name, mr_set_label, is_dichotomy, counted_value, var_names,
                                            num_vars)
    end

    def add_mult_resp_def_ext(handle, p_set)
      check! LIBSPSSDIO.spssAddMultRespDefExt(handle, p_set.ptr)
    end

    def add_mult_resp_def_n(handle, mr_set_name, mr_set_label, is_dichotomy, counted_value, var_names, num_vars)
      check! LIBSPSSDIO.spssAddMultRespDefN(handle, mr_set_name, mr_set_label, is_dichotomy, counted_value, var_names,
                                            num_vars)
    end

    def add_var_attribute(handle, var_name, attrib_name, attrib_sub, attrib_text)
      check! LIBSPSSDIO.spssAddVarAttribute(handle, var_name, attrib_name, attrib_sub, attrib_text)
    end

    def close_append(handle)
      check! LIBSPSSDIO.spssCloseAppend(handle)
    end

    def close_read(handle)
      check! LIBSPSSDIO.spssCloseRead(handle)
    end

    def close_write(handle)
      check! LIBSPSSDIO.spssCloseWrite(handle)
    end

    def commit_case_record(handle)
      check! LIBSPSSDIO.spssCommitCaseRecord(handle)
    end

    def commit_header(handle)
      check! LIBSPSSDIO.spssCommitHeader(handle)
    end

    def convert_date(day, month, year)
      spss_date = FFI::MemoryPointer.new(:double)
      check! LIBSPSSDIO.spssConvertDate(day, month, year, spss_date)
      spss_date.read_double
    end

    def convert_spss_date(spss_date)
      day = FFI::MemoryPointer.new(:int)
      month = FFI::MemoryPointer.new(:int)
      year = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssConvertSPSSDate(day, month, year, spss_date)
      [day.read_int, month.read_int, year.read_int]
    end

    def convert_spss_time(spss_time)
      day = FFI::MemoryPointer.new(:long)
      hour = FFI::MemoryPointer.new(:int)
      minute = FFI::MemoryPointer.new(:int)
      second = FFI::MemoryPointer.new(:double)
      check! LIBSPSSDIO.spssConvertSPSSTime(day, hour, minute, second, spss_time)
      [day.read_long, hour.read_int, minute.read_int, second.read_double]
    end

    def convert_time(day, hour, minute, second)
      spss_time = FFI::MemoryPointer.new(:double)
      check! LIBSPSSDIO.spssConvertTime(day, hour, minute, second, spss_time)
      spss_time.read_double
    end

    def copy_documents(from_handle, to_handle)
      check! LIBSPSSDIO.spssCopyDocuments(from_handle, to_handle)
    end

    def get_case_size(handle)
      result = FFI::MemoryPointer.new(:long)
      check! LIBSPSSDIO.spssGetCaseSize(handle, result)
      result.read_long
    end

    def get_case_weight_var(handle)
      result = FFI::MemoryPointer.new(:char, 65)
      check! LIBSPSSDIO.spssGetCaseWeightVar(handle, result)
      result.read_string
    end

    def get_compression(handle)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetCompression(handle, result)
      case result.read_int
      when 0
        :none
      when 1
        :standard
      when 2
        :zsav
      else
        result.read_int
      end
    end

    def get_date_variables(handle)
      num_of_elements = FFI::MemoryPointer.new(:int)
      date_info = FFI::MemoryPointer.new(:pointer)
      check! LIBSPSSDIO.spssGetDateVariables(handle, num_of_elements, date_info)
      date_info = date_info.read_pointer
      result = date_info.read_array_of_long(num_of_elements.read_int)
      check! LIBSPSSDIO.spssFreeDateVariables(date_info)
      result
    end

    def get_dew_guid(handle)
      result = FFI::MemoryPointer.new(:char, 257)
      check! LIBSPSSDIO.spssGetDEWGUID(handle, result)
      result.read_string
    end

    def get_dew_info(handle)
      length = FFI::MemoryPointer.new(:long)
      hash_total = FFI::MemoryPointer.new(:long)
      check! LIBSPSSDIO.spssGetDEWInfo(handle, length, hash_total)
      [length.read_long, hash_total.read_long]
    end

    def get_estimated_nof_cases(handle)
      result = FFI::MemoryPointer.new(:long)
      check! LIBSPSSDIO.spssGetEstimatedNofCases(handle, result)
      result.read_long
    end

    def get_file_attributes(handle)
      attrib_names = FFI::MemoryPointer.new(:pointer)
      attrib_text = FFI::MemoryPointer.new(:pointer)
      n_attributes = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetFileAttributes(handle, attrib_names, attrib_text, n_attributes)

      size = n_attributes.read_int
      if size.zero?
        []
      else
        p_attrib_names = attrib_names.read_pointer
        p_attrib_text = attrib_text.read_pointer
        attrib_names = p_attrib_names.read_array_of_string(size)
        attrib_text = p_attrib_text.read_array_of_string(size)
        check! LIBSPSSDIO.spssFreeAttributes(p_attrib_names, p_attrib_text, size)
        attrib_names.zip(attrib_text)
      end
    end

    def get_file_code_page(handle)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetFileCodePage(handle, result)
      result.read_int
    end

    def get_file_encoding(handle)
      result = FFI::MemoryPointer.new(:pointer)
      check! LIBSPSSDIO.spssGetFileEncoding(handle, result)
      result.read_string
    end

    def get_id_string(handle)
      result = FFI::MemoryPointer.new(:pointer)
      check! LIBSPSSDIO.spssGetIdString(handle, result)
      result.read_string
    end

    def get_interface_encoding
      LIBSPSSDIO.spssGetInterfaceEncoding
    end

    def get_mult_resp_count(handle)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetMultRespCount(handle, result)
      result.read_int
    end

    def get_mult_resp_def_by_index(handle, i_set)
      result = FFI::MemoryPointer.new(:pointer)
      check! LIBSPSSDIO.spssGetMultRespDefByIndex(handle, i_set, result)
      LIBSPSSDIO::MultRespDefManaged.new result.read_pointer
    end

    def get_mult_resp_defs(handle)
      mresp_defs = FFI::MemoryPointer.new(:pointer)
      check! LIBSPSSDIO.spssGetMultRespDefs(handle, mresp_defs)
      p_mresp_defs = mresp_defs.read_pointer
      result = p_mresp_defs.read_string
      check! LIBSPSSDIO.spssFreeMultRespDefs(p_mresp_defs)
      result
    end

    def get_mult_resp_defs_ex(handle)
      mresp_defs = FFI::MemoryPointer.new(:pointer)
      check! LIBSPSSDIO.spssGetMultRespDefsEx(handle, mresp_defs)
      p_mresp_defs = mresp_defs.read_pointer
      result = p_mresp_defs.read_string
      check! LIBSPSSDIO.spssFreeMultRespDefs(p_mresp_defs)
      result
    end

    def get_number_of_cases(handle)
      result = FFI::MemoryPointer.new(:long)
      check! LIBSPSSDIO.spssGetNumberofCases(handle, result)
      result.read_long
    end

    def get_number_of_variables(handle)
      result = FFI::MemoryPointer.new(:long)
      check! LIBSPSSDIO.spssGetNumberofVariables(handle, result)
      result.read_long
    end

    def get_release_info(handle)
      result = FFI::MemoryPointer.new(:int, 8)
      check! LIBSPSSDIO.spssGetReleaseInfo(handle, result)
      result.read_array_of_int(8)
    end

    def get_system_string(handle)
      result = FFI::MemoryPointer.new(:char, 41)
      check! LIBSPSSDIO.spssGetSystemString(handle, result)
      result.read_string
    end

    def get_text_info(handle)
      result = FFI::MemoryPointer.new(:char, 256)
      check! LIBSPSSDIO.spssGetTextInfo(handle, result)
      result.read_string
    end

    def get_time_stamp(handle)
      file_date = FFI::MemoryPointer.new(:char, 10)
      file_time = FFI::MemoryPointer.new(:char, 9)
      check! LIBSPSSDIO.spssGetTimeStamp(handle, file_date, file_time)
      [file_date.read_string, file_time.read_string]
    end

    def get_value_char(handle, var_handle, value_size)
      result = FFI::MemoryPointer.new(:char, value_size + 1)
      check! LIBSPSSDIO.spssGetValueChar(handle, var_handle, result, value_size + 1)
      result.read_string.rstrip
    end

    def get_value_numeric(handle, var_handle)
      result = FFI::MemoryPointer.new(:double)
      check! LIBSPSSDIO.spssGetValueNumeric(handle, var_handle, result)
      result.read_double
    end

    def get_var_alignment(handle, var_name)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarAlignment(handle, var_name, result)
      result.read_int
    end

    def get_var_attributes(handle, var_name)
      attrib_names = FFI::MemoryPointer.new(:pointer)
      attrib_text = FFI::MemoryPointer.new(:pointer)
      n_attributes = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarAttributes(handle, var_name, attrib_names, attrib_text, n_attributes)
      size = n_attributes.read_int
      if size.zero?
        []
      else
        p_attrib_names = attrib_names.read_pointer
        p_attrib_text = attrib_text.read_pointer
        attrib_names = p_attrib_names.read_array_of_string(size)
        attrib_text = p_attrib_text.read_array_of_string(size)
        call spssFreeAttributes(p_attrib_names, p_attrib_text, size)
        attrib_names.zip(attrib_text)
      end
    end

    def get_var_c_missing_values(handle, var_name)
      format = FFI::MemoryPointer.new(:int)
      val1 = FFI::MemoryPointer.new(:char, 9)
      val2 = FFI::MemoryPointer.new(:char, 9)
      val3 = FFI::MemoryPointer.new(:char, 9)
      check! LIBSPSSDIO.spssGetVarCMissingValues(handle, var_name, format, val1, val2, val3)
      n = format.read_int
      [val1.read_string, val2.read_string, val3.read_string].take(n)
    end

    def get_var_column_width(handle, var_name)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarColumnWidth(handle, var_name, result)
      result.read_int
    end

    def get_var_compat_name(handle, long_name)
      result = FFI::MemoryPointer.new(:char, 9)
      check! LIBSPSSDIO.spssGetVarCompatName(handle, long_name, result)
      result.read_string
    end

    def get_var_c_value_label(handle, var_name, value)
      result = FFI::MemoryPointer.new(:char, 61)
      check! LIBSPSSDIO.spssGetVarCValueLabel(handle, var_name, value, result)
      result.read_string
    end

    def get_var_c_value_label_long(handle, var_name, value, len_buff)
      label_buff = FFI::MemoryPointer.new(:char, len_buff)
      len_label = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarCValueLabelLong(handle, var_name, value, label_buff, len_buff, len_label)
      [len_label.read_int, label_buff.read_string]
    end

    def get_var_c_value_labels(handle, var_name)
      values = FFI::MemoryPointer.new(:pointer)
      labels = FFI::MemoryPointer.new(:pointer)
      num_labels = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarCValueLabels(handle, var_name, values, labels, num_labels)
      num_labels = num_labels.read_int
      if num_labels.zero?
        []
      else
        p_values = values.read_pointer
        p_labels = labels.read_pointer
        values = p_values.read_array_of_string(num_labels)
        labels = p_labels.read_array_of_string(num_labels)
        check! LIBSPSSDIO.spssFreeVarCValueLabels(values, labels, num_labels)
        values.zip(labels)
      end
    end

    def get_var_handle(handle, var_name)
      result = FFI::MemoryPointer.new(:double)
      check! LIBSPSSDIO.spssGetVarHandle(handle, var_name, result)
      result.read_double
    end

    def get_variable_sets(handle)
      result = FFI::MemoryPointer.new(:pointer)
      check! LIBSPSSDIO.spssGetVariableSets(handle, result)
      p = result.read_pointer
      result = p.read_string
      check! LIBSPSSDIO.spssFreeVariableSets(p)
      result
    end

    def get_var_info(handle, i_var)
      var_name = FFI::MemoryPointer.new(:char, 65)
      var_type = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarInfo(handle, i_var, var_name, var_type)
      [var_type.read_int, var_name.read_string]
    end

    def get_var_label(handle, var_name)
      var_label = FFI::MemoryPointer.new(:char, 121)
      check! LIBSPSSDIO.spssGetVarLabel(handle, var_name, var_label)
      var_label.read_string
    end

    def get_var_label_long(handle, var_name, len_buff)
      label_buff = FFI::MemoryPointer.new(:char, len_buff)
      len_label = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarLabelLong(handle, var_name, label_buff, len_buff, len_label)
      [len_label.read_int, label_buff.read_string]
    end

    def get_var_measure_level(handle, var_name)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarMeasureLevel(handle, var_name, result)
      result.read_int
    end

    def get_var_n_missing_values(handle, var_name)
      format = FFI::MemoryPointer.new(:int)
      val1 = FFI::MemoryPointer.new(:double)
      val2 = FFI::MemoryPointer.new(:double)
      val3 = FFI::MemoryPointer.new(:double)
      check! LIBSPSSDIO.spssGetVarNMissingValues(handle, var_name, format, val1, val2, val3)
      n = format.read_int
      [val1.read_double, val2.read_double, val3.read_double].take(n)
    end

    def get_var_n_value_label(handle, var_name, value)
      result = FFI::MemoryPointer.new(:char, 61)
      check! LIBSPSSDIO.spssGetVarNValueLabel(handle, var_name, value, result)
      result.read_string
    end

    def get_var_n_value_label_long(handle, var_name, value, len_buff)
      label_buff = FFI::MemoryPointer.new(:char, len_buff)
      len_label = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarNValueLabelLong(handle, var_name, value, label_buff, len_buff, len_label)
      [len_label.read_int, label_buff.read_string]
    end

    def get_var_n_value_labels(handle, var_name)
      values = FFI::MemoryPointer.new(:pointer)
      labels = FFI::MemoryPointer.new(:pointer)
      num_labels = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarNValueLabels(handle, var_name, values, labels, num_labels)
      num_labels = num_labels.read_int
      if num_labels.zero?
        []
      else
        p_values = values.read_pointer
        p_labels = labels.read_pointer
        values = p_values.read_array_of_double(num_labels)
        labels = p_labels.get_array_of_string(0, num_labels)
        check! LIBSPSSDIO.spssFreeVarNValueLabels(p_values, p_labels, num_labels)
        values.zip(labels)
      end
    end

    def get_var_names(handle)
      num_vars = FFI::MemoryPointer.new(:int)
      var_names = FFI::MemoryPointer.new(:pointer)
      var_types = FFI::MemoryPointer.new(:pointer)
      check! LIBSPSSDIO.spssGetVarNames(handle, num_vars, var_names, var_types)
      num_vars = num_vars.read_int
      if num_vars.zero?
        []
      else
        p_var_names = var_names.read_pointer
        p_var_types = var_types.read_pointer
        var_names = p_var_names.get_array_of_string(0, num_vars)
        var_types = p_var_types.read_array_of_int(num_vars)
        check! LIBSPSSDIO.spssFreeVarNames(p_var_names, p_var_types, num_vars)
        var_names.zip(var_types)
      end
    end

    def get_var_print_format(handle, var_name)
      print_type = FFI::MemoryPointer.new(:int)
      print_dec = FFI::MemoryPointer.new(:int)
      print_wid = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarPrintFormat(handle, var_name, print_type, print_dec, print_wid)
      [print_type.read_int, print_dec.read_int, print_wid.read_int]
    end

    def get_var_role(handle, var_name)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarRole(handle, var_name, result)
      result.read_int
    end

    def get_var_write_format(handle, var_name)
      var_role = FFI::MemoryPointer.new(:int)
      write_type = FFI::MemoryPointer.new(:int)
      write_dec = FFI::MemoryPointer.new(:int)
      write_wid = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssGetVarWriteFormat(handle, var_name, var_role, write_type, write_dec, write_wid)
      [var_role.read_int, write_type.read_int, write_dec.read_int, write_wid.read_int]
    end

    def host_sysmis_val
      result = FFI::MemoryPointer.new(:double)
      check! LIBSPSSDIO.spssHostSysmisVal(result)
      result.read_double
    end

    def is_compatible_encoding(handle)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssIsCompatibleEncoding(handle, result)
      result.read_int
    end

    def low_high_val
      lowest = FFI::MemoryPointer.new(:double)
      highest = FFI::MemoryPointer.new(:double)
      check! LIBSPSSDIO.spssLowHighVal(lowest, highest)
      [lowest.read_double, highest.read_double]
    end

    def open_append(path)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenAppend(path, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_append(result)
      else
        result
      end
    end

    def open_append_ex(path, password)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenAppendEx(path, password, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_append(result)
      else
        result
      end
    end

    def open_read(path)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenRead(path, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_read(result)
      else
        result
      end
    end

    def open_read_ex(path, password)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenReadEx(path, password, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_read(result)
      else
        result
      end
    end

    def open_write(path)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenWrite(path, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_write(result)
      else
        result
      end
    end

    def open_write_ex(path, password)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenWriteEx(path, password, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_write(result)
      else
        result
      end
    end

    def open_write_copy(path, dict_file_name)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenWriteCopy(path, dict_file_name, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_write(result)
      else
        result
      end
    end

    def open_write_copy_ex(path, password, dict_file_name, dict_password)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenWriteCopyEx(path, password, dict_file_name, dict_password, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_write(result)
      else
        result
      end
    end

    def open_write_copy_ex_file(path, password, dict_file_name)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenWriteCopyExFile(path, password, dict_file_name, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_write(result)
      else
        result
      end
    end

    def open_write_copy_ex_dict(path, dict_file_name, dict_password)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssOpenWriteCopyExDict(path, dict_file_name, dict_password, result)
      result = result.read_int
      if block_given?
        yield(result)
        close_write(result)
      else
        result
      end
    end

    def query_type7(handle, sub_type)
      result = FFI::MemoryPointer.new(:int)
      check! LIBSPSSDIO.spssQueryType7(handle, sub_type, result)
      result.read_int != 0
    end

    def read_case_record(handle)
      check! LIBSPSSDIO.spssReadCaseRecord(handle)
    end

    def seek_next_case(handle, case_number)
      check! LIBSPSSDIO.spssSeekNextCase(handle, case_number)
    end

    def set_case_weight_var(handle, var_name)
      check! LIBSPSSDIO.spssSetCaseWeightVar(handle, var_name)
    end

    def set_compression(handle, comp_switch)
      check! LIBSPSSDIO.spssSetCompression(handle, comp_switch)
    end

    def set_date_variables(handle, date_info)
      p_date_info = FFI::MemoryPointer.new(:long, date_info.size)
      p_date_info.write_array_of_long(date_info)
      check! LIBSPSSDIO.spssSetDateVariables(handle, date_info.size, p_date_info)
    end

    def set_dew_guid(handle, ascii_guid)
      check! LIBSPSSDIO.spssSetDEWGUID(handle, ascii_guid)
    end

    def set_file_attributes(handle, attributes)
      attrib_names = string_array(attributes.map(&:first))
      attrib_text = string_array(attributes.map(&:last))
      check! LIBSPSSDIO.spssSetFileAttributes(handle, attrib_names, attrib_text, attributes.size)
    end

    def set_id_string(handle, id)
      check! LIBSPSSDIO.spssSetIdString(handle, id)
    end

    def set_interface_encoding(encoding)
      check! LIBSPSSDIO.spssSetInterfaceEncoding(encoding)
    end

    def set_locale(category, locale)
      LIBSPSSDIO.spssSetLocale(category, locale)
    end

    def set_mult_resp_defs(handle, mresp_defs)
      check! LIBSPSSDIO.spssSetMultRespDefs(handle, mresp_defs)
    end

    def set_temp_dir(dir_name)
      check! LIBSPSSDIO.spssSetTempDir(dir_name)
    end

    def set_text_info(handle, text_info)
      check! LIBSPSSDIO.spssSetTextInfo(handle, text_info)
    end

    def set_value_char(handle, var_handle, value)
      check! LIBSPSSDIO.spssSetValueChar(handle, var_handle, value)
    end

    def set_value_numeric(handle, var_handle, value)
      check! LIBSPSSDIO.spssSetValueNumeric(handle, var_handle, value)
    end

    def set_var_alignment(handle, var_name, alignment)
      check! LIBSPSSDIO.spssSetVarAlignment(handle, var_name, alignment)
    end

    def set_var_attributes(handle, var_name, attributes)
      attrib_names = string_array(attributes.map(&:first))
      attrib_text = string_array(attributes.map(&:last))
      check! LIBSPSSDIO.spssSetVarAttributes(handle, var_name, attrib_names, attrib_text, attributes.size)
    end

    def set_var_c_missing_values(handle, var_name, missing)
      missing_val1, missing_val2, missing_val3 = missing
      check! LIBSPSSDIO.spssSetVarCMissingValues(handle, var_name, missing.size, missing_val1, missing_val2,
                                                 missing_val3)
    end

    def set_var_column_width(handle, var_name, column_width)
      check! LIBSPSSDIO.spssSetVarColumnWidth(handle, var_name, column_width)
    end

    def set_var_c_value_label(handle, var_name, value, label)
      check! LIBSPSSDIO.spssSetVarCValueLabel(handle, var_name, value, label)
    end

    def set_var_c_value_labels(handle, var_name, value_labels)
      values = string_array(value_labels.map(&:first))
      labels = string_array(value_labels.map(&:last))
      check! LIBSPSSDIO.spssSetVarCValueLabels(handle, var_name, values, labels, value_labels.size)
    end

    def set_var_label(handle, var_name, var_label)
      check! LIBSPSSDIO.spssSetVarLabel(handle, var_name, var_label)
    end

    def set_var_measure_level(handle, var_name, measure_level)
      check! LIBSPSSDIO.spssSetVarMeasureLevel(handle, var_name, measure_level)
    end

    def set_var_n_missing_values(handle, var_name, missing)
      missing_val1, missing_val2, missing_val3 = missing
      check! LIBSPSSDIO.spssSetVarNMissingValues(handle, var_name, missing.size, missing_val1, missing_val2,
                                                 missing_val3)
    end

    def set_var_n_value_label(handle, var_name, value, label)
      check! LIBSPSSDIO.spssSetVarNValueLabel(handle, var_name, value, label)
    end

    def set_var_n_value_labels(handle, var_names, value_labels)
      vars = string_array(var_names)
      values = numeric_array(value_labels.map(&:first))
      labels = string_array(value_labels.map(&:last))
      check! LIBSPSSDIO.spssSetVarNValueLabels(handle, vars, var_names.size, values, labels, value_labels.size)
    end

    def set_var_name(handle, var_name, var_length)
      check! LIBSPSSDIO.spssSetVarName(handle, var_name, var_length)
    end

    def set_var_print_format(handle, var_name, print_type, print_dec, print_wid)
      check! LIBSPSSDIO.spssSetVarPrintFormat(handle, var_name, print_type, print_dec, print_wid)
    end

    def set_var_role(handle, var_name, var_role)
      check! LIBSPSSDIO.spssSetVarRole(handle, var_name, var_role)
    end

    def set_var_write_format(handle, var_name, write_type, write_dec, write_wid)
      check! LIBSPSSDIO.spssSetVarWriteFormat(handle, var_name, write_type, write_dec, write_wid)
    end

    def set_variable_sets(handle, var_sets)
      check! LIBSPSSDIO.spssSetVarariableSets(handle, var_sets)
    end

    def sysmis_val
      LIBSPSSDIO.spssSysmisVal
    end

    def validate_varname(var_name)
      Status.name_status LIBSPSSDIO.spssValidateVarname(var_name)
    end

    def whole_case_in(handle)
      sz = get_case_size(handle)
      case_rec = FFI::MemoryPointer.new(:char, sz)
      check! LIBSPSSDIO.spssWholeCaseIn(handle, case_rec)
      case_rec
    end

    def whole_case_out(handle, case_rec)
      check! LIBSPSSDIO.spssWholeCaseOut(handle, case_rec)
    end
    # rubocop:enable Naming/PredicateName, Naming/AccessorMethodName

    # TODO: def get_dew_first; end
    # TODO: def get_dew_next; end
    # TODO: def set_dew_first; end
    # TODO: def set_dew_next; end

    private

    def check!(code)
      Status.status!(code)
    end

    def numeric_array(numbers)
      result = FFI::MemoryPointer.new(:pointer, numbers.size)
      result.write_array_of_double(numbers)
      result
    end

    def string_array(strings)
      result = FFI::MemoryPointer.new(:pointer, strings.size)
      result.write_array_of_pointer(strings.map { |s| FFI::MemoryPointer.from_string(s) })
      result
    end
  end

  class API
    extend IO
  end
end
