# frozen_string_literal: true

module SPSS
  class Error < StandardError; end
  class Warning < Error; end

  module Status
    WARNINGS = %i[exc_len64 exc_varlabel unknown_warning_3 exc_vallabel file_end no_varsets empty_varsets no_labels no_label no_casewgt no_dateinfo no_multresp empty_multresp no_dew empty_dew].freeze
    ERRORS = %i[file_oerror file_werror file_rerror fitab_full invalid_handle invalid_file no_memory open_rdmode open_wrmode invalid_varname dict_empty var_notfound dup_var nume_exp str_exp shortstr_exp invalid_vartype invalid_missfor invalid_compsw invalid_prfor invalid_wrfor invalid_date invalid_time no_variables mixed_types unknown_error_26 dup_value invalid_casewgt incompatible_dict dict_commit dict_notcommit unknown_error_32 no_type2
                unknown_error_33 unknown_error_34 unknown_error_35 unknown_error_36 unknown_error_37 unknown_error_38 unknown_error_39 unknown_error_40
                no_type73 unknown_error_42 unknown_error_43 unknown_error_44
                invalid_dateinfo no_type999 exc_strvalue cannot_free buffer_short invalid_case internal_vlabs incompat_append internal_d_a file_badtemp dew_nofirst invalid_measurelevel invalid_7subtype invalid_varhandle invalid_encoding files_open
                unknown_error_61 unknown_error_62 unknown_error_63 unknown_error_64 unknown_error_65 unknown_error_66 unknown_error_67 unknown_error_68 unknown_error_69
                invalid_mrsetdef invalid_mrsetname dup_mrsetname bad_extension invalid_extendedstriNG invalid_attrname invalid_attrdef invalid_mrsetindex invalid_varsetdef invalid_role invalid_password empty_password].freeze

    NAME_CODES = %i[ok scratch system badlth badchar reserved badfirst].freeze

    def self.status(code)
      return :ok if code.zero?
      return WARNINGS[-code - 1] || :"unknown_warning_#{-code}" if code < 0

      ERRORS[code - 1] || :"unknown_error_#{code}"
    end

    def self.status!(code)
      return if code.zero?
      raise Warning, status(code) if code < 0

      raise Error, status(code)
    end

    def self.name_status(code)
      NAME_CODES[code] || :"unknown_name_status_#{code}"
    end
  end
end
