# frozen_string_literal: true

require "spssio/api"
require "tempfile"
require "csv" # TODO: remove

RSpec.describe SPSS::API do
  # subject { Class.new { extend SPSS::API } }
  subject { SPSS::API }

  it "offers access to the interface encoding" do
    expect(subject.get_interface_encoding).to be_a Numeric
  end

  # NOTE: these can't be reliably called once the library has actually "done" anything so the test is currently suppressed
  it "can set the interface encoding", :not_tested do
    expect { subject.set_interface_encoding(SPSS::ENCODING_UTF8) }.not_to raise_exception
    expect { subject.set_interface_encoding(SPSS::ENCODING_CODEPAGE) }.not_to raise_exception
  end

  it "can return the system-missing value" do
    expect(subject.sysmis_val).to be_a Numeric
  end

  it "can return the host-format-independent system-missing value" do
    expect(subject.host_sysmis_val).to be_a Numeric
  end

  it "can return the lowest and highest values used for numeric missing value ranges" do
    expect(subject.low_high_val).to match [Numeric, Numeric]
  end

  it "converts day/month/year to SPSS date format" do
    expect(subject.convert_date(22, 2, 1963)).to eq 12_002_947_200.0
  end

  it "converts day/hour/minute/second to SPSS time format" do
    expect(subject.convert_time(1, 12, 0, 0.5)).to eq 129_600.5
  end

  it "converts SPSS date format to day/month/year" do
    expect(subject.convert_spss_date(12_002_947_200.0)).to eq [22, 2, 1963]
  end

  it "converts SPSS time format to day/hour/minute/second" do
    expect(subject.convert_spss_time(129_600.5)).to eq [1, 12, 0, 0.5]
  end

  it "can set the locale" do
    expect(subject.set_locale(0, "en_US.UTF-8")).to eq "en_US.UTF-8"
  end

  it "can set the temp directory" do
    expect { subject.set_temp_dir(ENV.fetch("TMPDIR", nil)) }.not_to raise_exception
  end

  it "can validate proposed variable names" do
    expect(subject.validate_varname("gender")).to eq :ok
    expect(subject.validate_varname("#gender")).to eq :scratch
    expect(subject.validate_varname("$gender")).to eq :system
    expect(subject.validate_varname("gender" * 30)).to eq :badlth
    expect(subject.validate_varname("gen^der")).to eq :badchar
    expect(subject.validate_varname("ALL")).to eq :reserved
    expect(subject.validate_varname("1gender")).to eq :badfirst
  end

  context "opening SAV files for reading" do
    let(:savfile) { File.join("fixtures", "MA2912GSSONE.sav") }

    it "opens (and closes) existing SAV files" do
      handle = subject.open_read(savfile)
      expect(handle).to be_a Numeric
      subject.close_read(handle)
    end

    it "opens existing SAV files with a password" do
      handle = subject.open_read_ex(savfile, "secret")
      expect(handle).to be_a Numeric
      subject.close_read(handle)
    end
  end

  context "opening SAV files for writing" do
    let(:savfile) { Tempfile.new("spssio") }

    after do
      savfile.unlink
    end

    it "creates (and closes) SAV files for writing" do
      handle = subject.open_write(savfile.path)
      expect(handle).to be_a Numeric
      subject.close_write(handle)
    end

    it "creates SAV files with a password" do
      handle = subject.open_write_ex(savfile.path, "secret")
      expect(handle).to be_a Numeric
      subject.close_write(handle)
    end
  end

  context "opening SAV files for append" do
    let(:original) { File.join("fixtures", "MA2912GSSONE.sav") }
    let(:savfile) { Tempfile.new("spssio") }

    before do
      FileUtils.cp(original, savfile.path)
    end

    after do
      savfile.unlink
    end

    it "creates (and closes) SAV files for writing" do
      handle = subject.open_append(savfile.path)
      expect(handle).to be_a Numeric
      subject.close_append(handle)
    end

    it "creates SAV files with a password" do
      handle = subject.open_append_ex(savfile.path, "secret")
      expect(handle).to be_a Numeric
      subject.close_append(handle)
    end
  end

  context "write copy", :not_tested do
    it "can open a file in copy mode (#open_write_copy)"
    it "can handle both files needing passwords (#open_write_copy_ex)"
    it "can handle the target file needing a password (#open_write_copy_ex_file)"
    it "can handle the source file needing a password (#open_write_copy_ex_dict)"
  end

  it "can copy documents from one SAV file to another (#copy_documents)", :not_tested

  context "with a file open for reading" do
    let(:handle) { subject.open_read(@savfile.path) }

    before(:context) do
      original = File.join("fixtures", "MA2912GSSONE.sav")
      @savfile = Tempfile.new("spssio")
      FileUtils.cp(original, @savfile.path)
    end

    after(:context) do
      @savfile.unlink
    end

    after do
      subject.close_read(handle)
    end

    it "can get the case size" do
      expect(subject.get_case_size(handle)).to eq 61_696
    end

    it "can read the case weight variable name" do
      expect { subject.get_case_weight_var(handle) }.to raise_error SPSS::Warning, "no_casewgt"
    end

    it "can get the compression attribute" do
      expect(subject.get_compression(handle)).to eq :standard
    end

    it "can report the forcasting (trends) date variable information" do
      expect { subject.get_date_variables(handle) }.to raise_exception SPSS::Warning, "no_dateinfo"
    end

    it "can read the DEW GUID" do
      expect(subject.get_dew_guid(handle)).to eq ""
    end

    it "can read the DEW info" do
      expect { subject.get_dew_info(handle) }.to raise_exception SPSS::Warning, "no_dew"
    end

    it "can estimate the number of cases" do
      expect(subject.get_estimated_nof_cases(handle)).to eq 1009
    end

    it "can read the file attributes" do
      expect(subject.get_file_attributes(handle)).to eq []
    end

    it "can read the file code page" do
      expect(subject.get_file_code_page(handle)).to eq 1252
    end

    it "can read the file encoding" do
      expect(subject.get_file_encoding(handle)).to eq "windows-"
    end

    it "can read the file id string" do
      expect(subject.get_id_string(handle)).to eq ""
    end

    it "can get the number of multiple response sets" do
      expect(subject.get_mult_resp_count(handle)).to eq 8
    end

    it "can get the multiple response sets" do
      expect(subject.get_mult_resp_defs(handle)).to eq <<~DEFS
        $AllowedProvider=D1 1 23 Allowed Sample Provider AllowedProvider01 AllowedProvider02 AllowedProvider03 AllowedProvider04 AllowedProvider05 AllowedProvider06 AllowedProvider07 AllowedProvider08 AllowedProvider09 AllowedProvider10
        $RACE=D1 1 106 Which of the following groups best represent your ethnic background? You may select <u>all</u> that apply. RACE1 RACE2 RACE3 RACE4 RACE5 RACE6 RACE7 RACE8
        $TODAYWATCH=D1 1 92 Please identify the types of TV shows you have watched today? You may select all that apply. TODAYWATCH1 TODAYWATCH2 TODAYWATCH3 TODAYWATCH4 TODAYWATCH5 TODAYWATCH6
        $WHICHNEWS=D1 1 111 Please indicate which, if any, of the following in-depth news or news magazine programs you have watched today. WHICHNEWS1 WHICHNEWS2 WHICHNEWS3 WHICHNEWS4 WHICHNEWS5 WHICHNEWS6 WHICHNEWS7
        $PRG_POSTATTRIBUTES=D1 1 18 PRG_POSTATTRIBUTES PRG_POSTATTRIBUTES1 PRG_POSTATTRIBUTES2 PRG_POSTATTRIBUTES3 PRG_POSTATTRIBUTES4 PRG_POSTATTRIBUTES5 PRG_POSTATTRIBUTES6
        $QTA_POSTATTRIBUTES=D1 1 18 QTA_POSTATTRIBUTES QTA_POSTATTRIBUTES1 QTA_POSTATTRIBUTES2 QTA_POSTATTRIBUTES3 QTA_POSTATTRIBUTES4 QTA_POSTATTRIBUTES5 QTA_POSTATTRIBUTES6
        $StraightLiner=D1 1 23 StraightLiner Questions StraightLiner1 StraightLiner2 StraightLiner3
        $StraightLinerCount=D1 1 18 StraightLinerCount StraightLinerCount1 StraightLinerCount2 StraightLinerCount3 StraightLinerCount4
      DEFS
    end

    it "can get the multiple-response sets for extended multiple dichotomy sets" do
      expect(subject.get_mult_resp_defs_ex(handle)).to eq <<~DEFS
        $AllowedProvider=D1 1 23 Allowed Sample Provider AllowedProvider01 AllowedProvider02 AllowedProvider03 AllowedProvider04 AllowedProvider05 AllowedProvider06 AllowedProvider07 AllowedProvider08 AllowedProvider09 AllowedProvider10
        $RACE=D1 1 106 Which of the following groups best represent your ethnic background? You may select <u>all</u> that apply. RACE1 RACE2 RACE3 RACE4 RACE5 RACE6 RACE7 RACE8
        $TODAYWATCH=D1 1 92 Please identify the types of TV shows you have watched today? You may select all that apply. TODAYWATCH1 TODAYWATCH2 TODAYWATCH3 TODAYWATCH4 TODAYWATCH5 TODAYWATCH6
        $WHICHNEWS=D1 1 111 Please indicate which, if any, of the following in-depth news or news magazine programs you have watched today. WHICHNEWS1 WHICHNEWS2 WHICHNEWS3 WHICHNEWS4 WHICHNEWS5 WHICHNEWS6 WHICHNEWS7
        $PRG_POSTATTRIBUTES=D1 1 18 PRG_POSTATTRIBUTES PRG_POSTATTRIBUTES1 PRG_POSTATTRIBUTES2 PRG_POSTATTRIBUTES3 PRG_POSTATTRIBUTES4 PRG_POSTATTRIBUTES5 PRG_POSTATTRIBUTES6
        $QTA_POSTATTRIBUTES=D1 1 18 QTA_POSTATTRIBUTES QTA_POSTATTRIBUTES1 QTA_POSTATTRIBUTES2 QTA_POSTATTRIBUTES3 QTA_POSTATTRIBUTES4 QTA_POSTATTRIBUTES5 QTA_POSTATTRIBUTES6
        $StraightLiner=D1 1 23 StraightLiner Questions StraightLiner1 StraightLiner2 StraightLiner3
        $StraightLinerCount=D1 1 18 StraightLinerCount StraightLinerCount1 StraightLinerCount2 StraightLinerCount3 StraightLinerCount4
      DEFS
    end

    it "can get a multiple-response def by index" do
      defn = subject.get_mult_resp_def_by_index(handle, 2)
      expect(defn[:mr_set_name].to_s).to eq "$TODAYWATCH"
      expect(defn[:mr_set_label].to_s).to eq "Please identify the types of TV shows you have watched today? You may select all that apply."
      expect(defn[:is_dichotomy]).to eq 1
      expect(defn[:is_numeric]).to eq 1
      expect(defn[:use_category_labels]).to eq 0
      expect(defn[:use_first_var_label]).to eq 0
      expect(defn[:n_counted_value]).to eq 1
      expect(defn[:c_counted_value]).to eq "1"
      expect(defn[:n_variables]).to eq 6
      n = defn[:n_variables]
      ps = defn[:var_names].read_array_of_pointer(n).map(&:read_string)
      expect(ps).to eq %w[TODAYWATCH1 TODAYWATCH2 TODAYWATCH3 TODAYWATCH4 TODAYWATCH5 TODAYWATCH6]
    end

    it "can read the number of cases" do
      expect(subject.get_number_of_cases(handle)).to eq 1009
    end

    it "can read the number of variables" do
      expect(subject.get_number_of_variables(handle)).to eq 225
    end

    it "can read the release info" do
      expect(subject.get_release_info(handle)).to eq [22, 0, 1, 0, 0, 0, 0, 0]
    end

    it "can read the system string" do
      expect(subject.get_system_string(handle)).to eq "MS Windows 22.0.0.1 spssio32.dll"
    end

    it "can read the text info" do
      expect(subject.get_text_info(handle)).to eq ""
    end

    it "can read the time stamp" do
      expect(subject.get_time_stamp(handle)).to eq ["02-Feb-19", "16:41:55"]
    end

    it "can read the variable sets" do
      expect { subject.get_variable_sets(handle) }.to raise_exception SPSS::Warning, "empty_varsets"
    end

    it "can test whether the file's encoding is compatible with the current interface encoding" do
      expect(subject.is_compatible_encoding(handle)).to be_truthy
    end

    it "can do query type 7 operations" do
      expect(subject.query_type7(handle, 3)).to be_truthy # release info
      expect(subject.query_type7(handle, 4)).to be_truthy # floating point constants including the system missing value
      expect(subject.query_type7(handle, 5)).to be_falsy # variable set definitions
      expect(subject.query_type7(handle, 6)).to be_falsy # date variable information
      expect(subject.query_type7(handle, 7)).to be_truthy # multiple-response set definitions
      expect(subject.query_type7(handle, 8)).to be_falsy # DEW information
      expect(subject.query_type7(handle, 10)).to be_falsy # TextSmart information
      expect(subject.query_type7(handle, 11)).to be_truthy # measurement level, column with, and alignment for each variable
    end

    it "can retrieve the variable names and types" do
      expect(subject.get_var_names(handle)).to include(["Respondent_Serial", 0], ["M2MError_Email", 1024])
    end

    context "a specific (named) variable" do
      it "can read the variable info by index", :not_tested # get_var_info(handle, i_var)
      it "can read the compatible variable name" do
        expect(subject.get_var_compat_name(handle, "M2MError_Email")).to eq "V4_A"
      end

      it "can read the variable label" do
        expect(subject.get_var_label(handle,
                                     "M2MError_Email")).to eq "Thank you for your willingness to help.<p>Initially, we will contact you by email.  Again, this contact would only be fo"
      end

      it "can read the variable label (long form)" do
        # TODO: this doesn't seem to be returning the full label, but rather only the first 256 bytes
        text = "Thank you for your willingness to help.<p>Initially, we will contact you by email.  Again, this contact would only be for the purpose of identifying the cause of the problem that was detected, and if we contact you we will pay you $25.</p>What email addres"
        expect(subject.get_var_label_long(handle, "M2MError_Email", 1024)).to eq [256, text]
      end

      it "can obtain a handle for a variable" do
        expect(subject.get_var_handle(handle, "M2MError_Email")).to be_a Numeric
      end

      it "can return a variable's alignment" do
        expect(subject.get_var_alignment(handle, "M2MError_Email")).to eq 0
      end

      it "can return a variable's column width" do
        expect(subject.get_var_column_width(handle, "M2MError_Email")).to eq 50
      end

      it "can return a variable's column width" do
        expect(subject.get_var_column_width(handle, "M2MError_Email")).to eq 50
      end

      it "can return a variable's measure level" do
        expect(subject.get_var_measure_level(handle, "M2MError_Email")).to eq 1
      end

      it "can return a variable's role" do
        expect(subject.get_var_role(handle, "M2MError_Email")).to eq 0
      end

      it "can return a variable's write format" do
        expect(subject.get_var_write_format(handle, "M2MError_Email")).to eq [1, 0, 1024, 0]
      end

      it "can return a variable's print format" do
        expect(subject.get_var_print_format(handle, "M2MError_Email")).to eq [1, 0, 1024]
      end

      it "can return the variable's attributes" do
        expect(subject.get_var_attributes(handle, "M2MError_Email")).to eq []
      end

      context "character variable" do
        it "can return the missing values" do
          expect(subject.get_var_c_missing_values(handle, "M2MError_Email")).to eq []
        end

        it "can return the value labels" do
          expect do
            subject.get_var_c_value_labels(handle, "M2MError_Email")
          end.to raise_exception SPSS::Warning, "no_labels"
        end

        it "can return the label for a single value" do
          expect do
            subject.get_var_c_value_label(handle, "M2MError_Email", "x")
          end.to raise_exception SPSS::Warning, "no_labels"
        end

        it "can return long labels" do
          expect do
            subject.get_var_c_value_label_long(handle, "M2MError_Email", "x", 256)
          end.to raise_exception SPSS::Warning, "no_labels"
        end
      end

      context "numeric variable" do
        it "can return the missing values" do
          expect(subject.get_var_n_missing_values(handle, "TODAYWATCH1")).to eq []
        end

        it "can return the value labels" do
          expect(subject.get_var_n_value_labels(handle, "TODAYWATCH1")).to eq [[0.0, "No"], [1.0, "Yes"]]
        end

        it "can return the label for a single value" do
          expect(subject.get_var_n_value_label(handle, "TODAYWATCH1", 1.0)).to eq "Yes"
        end

        it "can return long labels" do
          expect(subject.get_var_n_value_label_long(handle, "TODAYWATCH1", 1.0, 256)).to eq [3, "Yes"]
        end
      end
    end

    it "can read case records" do
      expect { subject.read_case_record(handle) }.not_to raise_exception
    end

    it "can seek to a specific case by index" do
      expect { subject.seek_next_case(handle, 3) }.not_to raise_exception
    end

    context "case data" do
      before do
        subject.read_case_record(handle)
      end

      context "character variable" do
        let(:c_var_handle) { subject.get_var_handle(handle, "M2MError_Email") }

        it "can retrieve the variable's value" do
          expect(subject.get_value_char(handle, c_var_handle, 2048)).to eq ""
        end
      end

      context "numeric variable" do
        let(:n_var_handle) { subject.get_var_handle(handle, "Respondent_Serial") }

        it "can retrieve the variable's value" do
          expect(subject.get_value_numeric(handle, n_var_handle)).to eq 84.0
        end
      end

      it "can read a whole case", :not_tested # whole_case_in(handle)
      it "can write a whole case", :not_tested # whole_case_out(handle, case_rec)
    end
  end

  context "with a file open for writing" do
    let(:savfile) { Tempfile.new("spssio") }
    let(:handle) { subject.open_write(savfile.path) }

    after do
      subject.close_write(handle)
      savfile.unlink
    end

    it "can set the case weight variable name", :not_tested do
      pending "the variable has to be defined"
      expect { subject.set_case_weight_var(handle, "Weight") }.not_to raise_error
    end

    it "can get the compression attribute" do
      expect { subject.set_compression(handle, 1) }.not_to raise_error
    end

    it "can report the forcasting (trends) date variable information", :not_tested do
      pending "learning what trend info looks like"
      subject.set_date_variables(handle, :something)
    end

    it "can set the DEW GUID", :not_tested do
      pending "having a proper GUID to use"
      expect(subject.set_dew_guid(handle, SecureRandom.uuid)).to eq ""
    end

    it "can set the file attributes" do
      expect { subject.set_file_attributes(handle, [["attr1", "val 1"], ["attr2", "val 2"]]) }.not_to raise_error
    end

    it "can set the file id string" do
      expect { subject.set_id_string(handle, "My File") }.not_to raise_error
    end

    it "can set the multiple response sets" do
      expect { subject.set_mult_resp_defs(handle, <<~DEFS) }.not_to raise_error
        $AllowedProvider=D1 1 23 Allowed Sample Provider AllowedProvider01 AllowedProvider02 AllowedProvider03 AllowedProvider04 AllowedProvider05 AllowedProvider06 AllowedProvider07 AllowedProvider08 AllowedProvider09 AllowedProvider10
        $RACE=D1 1 106 Which of the following groups best represent your ethnic background? You may select <u>all</u> that apply. RACE1 RACE2 RACE3 RACE4 RACE5 RACE6 RACE7 RACE8
        $TODAYWATCH=D1 1 92 Please identify the types of TV shows you have watched today? You may select all that apply. TODAYWATCH1 TODAYWATCH2 TODAYWATCH3 TODAYWATCH4 TODAYWATCH5 TODAYWATCH6
        $WHICHNEWS=D1 1 111 Please indicate which, if any, of the following in-depth news or news magazine programs you have watched today. WHICHNEWS1 WHICHNEWS2 WHICHNEWS3 WHICHNEWS4 WHICHNEWS5 WHICHNEWS6 WHICHNEWS7
        $PRG_POSTATTRIBUTES=D1 1 18 PRG_POSTATTRIBUTES PRG_POSTATTRIBUTES1 PRG_POSTATTRIBUTES2 PRG_POSTATTRIBUTES3 PRG_POSTATTRIBUTES4 PRG_POSTATTRIBUTES5 PRG_POSTATTRIBUTES6
        $QTA_POSTATTRIBUTES=D1 1 18 QTA_POSTATTRIBUTES QTA_POSTATTRIBUTES1 QTA_POSTATTRIBUTES2 QTA_POSTATTRIBUTES3 QTA_POSTATTRIBUTES4 QTA_POSTATTRIBUTES5 QTA_POSTATTRIBUTES6
        $StraightLiner=D1 1 23 StraightLiner Questions StraightLiner1 StraightLiner2 StraightLiner3
        $StraightLinerCount=D1 1 18 StraightLinerCount StraightLinerCount1 StraightLinerCount2 StraightLinerCount3 StraightLinerCount4
      DEFS
    end

    it "can read the text info" do
      expect { subject.set_text_info(handle, "My text info") }.not_to raise_error
    end

    it "can read the variable sets", :not_tested do
      pending "variable sets"
      expect { subject.set_variable_sets(handle) }.to raise_exception SPSS::Warning, "empty_varsets"
    end
  end

  it "can read what it writes" do
    file = Tempfile.new(["file", ".sav"])
    subject.open_write(file.path) do |handle|
      subject.set_id_string(handle, "My Sample SAV File")
      subject.set_compression(handle, 1)
      subject.set_var_name(handle, "Respondent_Serial", 0)
      subject.set_var_name(handle, "Location", 64)
      subject.set_var_name(handle, "Weight", 0)
      subject.set_case_weight_var(handle, "Weight")
      subject.commit_header(handle)
      rs = subject.get_var_handle(handle, "Respondent_Serial")
      lo = subject.get_var_handle(handle, "Location")
      wt = subject.get_var_handle(handle, "Weight")

      subject.set_value_numeric(handle, rs, 1.0)
      subject.set_value_char(handle, lo, "Washington, DC")
      subject.set_value_numeric(handle, wt, 2.0)
      subject.commit_case_record(handle)

      subject.set_value_numeric(handle, rs, 2)
      subject.set_value_char(handle, lo, "New York, NY")
      subject.set_value_numeric(handle, wt, 0.5)
      subject.commit_case_record(handle)
    end

    subject.open_read(file.path) do |handle|
      var_names = subject.get_var_names(handle)
      expect(var_names).to include(["Respondent_Serial", 0], ["Location", 64], ["Weight", 0])
      wt = subject.get_case_weight_var(handle)
      expect(wt).to eq "Weight"
      var_handles = var_names.each_with_object({}) do |(name, _), obj|
        obj[name] = subject.get_var_handle(handle, name)
      end

      out = StringIO.new
      CSV(out) do |csv|
        csv << var_names.map(&:first)
        subject.get_number_of_cases(handle).times do
          subject.read_case_record(handle)
          csv << var_names.map do |name, sz|
            if sz.zero?
              subject.get_value_numeric(handle, var_handles[name])
            else
              subject.get_value_char(handle, var_handles[name], sz + 1)
            end
          end
        end
      end
      out.rewind
      expect(out.string).to eq <<~OUT
        Respondent_Serial,Location,Weight
        1.0,"Washington, DC",2.0
        2.0,"New York, NY",0.5
      OUT

      file.unlink
    end
  end
end

# add_file_attribute(handle, attrib_name, attrib_sub, attrib_text)
# add_mult_resp_def_c(handle, mr_set_name, mr_set_label, is_dichotomy, counted_value, var_names, num_vars)
# add_mult_resp_def_ext(handle, p_set)
# add_mult_resp_def_n(handle, mr_set_name, mr_set_label, is_dichotomy, counted_value, var_names, num_vars)
# add_var_attribute(handle, var_name, attrib_name, attrib_sub, attrib_text)
# commit_case_record(handle)
# commit_header(handle)

# set_value_char(handle, var_handle, value)
# set_value_numeric(handle, var_handle, value)

# set_var_alignment(handle, var_name, alignment)
# set_var_attributes(handle, var_name, attributes)
# set_var_c_missing_values(handle, var_name, missing)
# set_var_column_width(handle, var_name, column_width)
# set_var_c_value_label(handle, var_name, value, label)
# set_var_c_value_labels(handle, var_name, value_labels)
# set_var_label(handle, var_name, var_label)
# set_var_measure_level(handle, var_name, measure_level)
# set_var_n_missing_values(handle, var_name, missing)
# set_var_n_value_label(handle, var_name, value, label)
# set_var_n_value_labels(handle, var_names, value_labels)
# set_var_name(handle, var_name, var_length)
# set_var_print_format(handle, var_name, print_type, print_dec, print_wid)
# set_var_role(handle, var_name, var_role)
# set_var_write_format(handle, var_name, write_type, write_dec, write_wid)
