# frozen_string_literal: true

require "ffi"
require "pathname"

module SPSS
  MAX_VARNAME = 64
  MAX_VARLABEL = 256

  ENCODING_CODEPAGE = 0
  ENCODING_UTF8 = 1

  module LIBSPSSDIO
    extend FFI::Library

    ffi_convention :stdcall

    def self.platform
      @platform ||= case RUBY_PLATFORM
                    when %r{^x86_64-linux(?:-.*)?$}
                      "lin64"
                    when %r{^x86_64-darwin(?:-.*)?}
                      "macos"
                    end
    end

    def self.path
      Pathname.new(__dir__).parent.parent.join("ext", platform) unless platform.nil?
    end

    def self.find(name)
      [name, *Dir.glob("#{path}/#{name}.*")]
    end

    begin
      ffi_lib find("libgsk8iccs")
    rescue LoadError # rubocop:disable Lint/SuppressedException
    end
    begin
      ffi_lib find("libgsk8iccs_64")
    rescue LoadError # rubocop:disable Lint/SuppressedException
    end
    ffi_lib find("libicudata")
    ffi_lib find("libicuuc")
    ffi_lib find("libicui18n")
    ffi_lib find("libzlib1211spss1")
    ffi_lib find("libspssdio")

    module MultRespDefLayout
      def self.included(base)
        base.class_eval do
          layout :mr_set_name, [:char, MAX_VARNAME + 1], # null-terminated MR set name
                 :mr_set_label, [:char, MAX_VARLABEL + 1], # null-terminated set label
                 :is_dichotomy, :int,
                 :is_numeric, :int,
                 :use_category_labels, :int,
                 :use_first_var_label, :int,
                 :reserved, [:int, 14],
                 :n_counted_value, :long,
                 :c_counted_value, :string,
                 :var_names, :pointer, # char**
                 :n_variables, :int
        end
      end
    end

    class MultRespDef < FFI::Struct
      include MultRespDefLayout
    end

    class MultRespDefManaged < FFI::ManagedStruct
      include MultRespDefLayout

      def self.release(ptr)
        SPSS::Status.status! LIBSPSSDIO.spssFreeMultRespDefStruct(ptr)
      end
    end

    # rubocop:disable Layout/LineLength
    attach_function :spssAddFileAttribute, %i[int string int string], :int # (const int handle, const char* attribName, const int attribSub, const char* attribText)
    attach_function :spssAddMultRespDefC, %i[int string string int string pointer int], :int # (int handle, const har* mrSetName, const char* mrSetLabel, int isDichotomy, const char* countedValue, const char** varNames, int numVars)
    attach_function :spssAddMultRespDefExt, %i[int pointer], :int # (int handle, const spssMultRespDef* pSet)
    attach_function :spssAddMultRespDefN, %i[int string string int long pointer int], :int # (int handle, const har* mrSetName, const char* mrSetLabel, int isDichotomy, long countedValue, const char** varNames, int numVars)
    attach_function :spssAddVarAttribute, %i[int string string int string], :int # (const int handle, const char* varName, const char* attribName, const int attribSub, const char* attribText)
    attach_function :spssCloseAppend, %i[int], :int
    attach_function :spssCloseRead, %i[int], :int
    attach_function :spssCloseWrite, %i[int], :int
    attach_function :spssCommitCaseRecord, %i[int], :int # (int handle)
    attach_function :spssCommitHeader, %i[int], :int # (const int handle)
    attach_function :spssConvertDate, %i[int int int pointer], :int # (int day, int month, int year, double* spssDate)
    attach_function :spssConvertSPSSDate, %i[pointer pointer pointer double], :int # (int* day, int* month, int* year, double spssDate)
    attach_function :spssConvertSPSSTime, %i[pointer pointer pointer pointer double], :int # (long* day, int* hour, int* minute, double* second, double spssTime)
    attach_function :spssConvertTime, %i[long int int double pointer], :int # (int day, int hour, int minute, double second, double* spssTime)
    attach_function :spssCopyDocuments, %i[int int], :int # (int fromHandle, int toHandle)
    attach_function :spssFreeAttributes, %i[pointer pointer int], :int # (char** attribNames, char** attribText, int nAttributes) -- spssGetFileAttributes, spssGetVarAttributes
    attach_function :spssFreeDateVariables, %i[pointer], :int # (long* dateInfo) -- spssGetDateVariables
    attach_function :spssFreeMultRespDefs, %i[pointer], :int # (char* mrespDefs) -- spssGetMultRespDefs
    attach_function :spssFreeMultRespDefStruct, %i[pointer], :int # (char* mrespDefStruct) -- spssGetMultRespDefByIndex
    attach_function :spssFreeVarCValueLabels, %i[pointer pointer int], :int # (char** values, char** labels, int numLabels) -- spssGetVarCValueLabels
    attach_function :spssFreeVariableSets, %i[pointer], :int # (char* varSets) -- spssGetVariableSets
    attach_function :spssFreeVarNValueLabels, %i[pointer pointer int], :int # (double* values, char** labels, int numLabels) -- spssGetVarNValueLabels
    attach_function :spssFreeVarNames, %i[pointer pointer int], :int # (char** values, int* types, int numVariables) -- spssGetVarNames
    attach_function :spssGetCaseSize, %i[int pointer], :int # (int handle, long* caseSize)
    attach_function :spssGetCaseWeightVar, %i[int pointer], :int
    attach_function :spssGetCompression, %i[int pointer], :int # (int handle, int* compSwitch)
    attach_function :spssGetDateVariables, %i[int pointer pointer], :int # (int handle, int* numofElements, long** dateInfo)
    attach_function :spssGetDEWFirst, %i[int pointer long pointer], :int # (const int handle, void* pData, const long maxData, long* nData)
    attach_function :spssGetDEWGUID, %i[int pointer], :int # (const int handle, char* asciiGUID)
    attach_function :spssGetDEWInfo, %i[int pointer pointer], :int # (const int handle, long* pLength, long* pHashTotal)
    attach_function :spssGetDEWNext, %i[int pointer long pointer], :int # (const int handle, void* pData, const long maxData, long* nData)
    attach_function :spssGetEstimatedNofCases, %i[int pointer], :int # (const int handle, long* caseCount)
    attach_function :spssGetFileAttributes, %i[int pointer pointer pointer], :int
    attach_function :spssGetFileCodePage, %i[int pointer], :int # (const int hFile, int* nCodePage)
    attach_function :spssGetFileEncoding, %i[int pointer], :int # (const int hFile, char* pszEncoding)
    attach_function :spssGetIdString, %i[int pointer], :int
    attach_function :spssGetInterfaceEncoding, %i[], :int
    attach_function :spssGetMultRespCount, %i[int pointer], :int # (const int hFile, int* nSets)
    attach_function :spssGetMultRespDefByIndex, %i[int int pointer], :int # (const int hFile, const int iSet, spssMultRespDef** ppSet)
    attach_function :spssGetMultRespDefs, %i[int pointer], :int # (const int hFile, char** mrespDefs)
    attach_function :spssGetMultRespDefsEx, %i[int pointer], :int # (const int hFile, char** mrespDefs)
    attach_function :spssGetNumberofCases, %i[int pointer], :int
    attach_function :spssGetNumberofVariables, %i[int pointer], :int # (int handle, long* numVars)
    attach_function :spssGetReleaseInfo, %i[int pointer], :int
    attach_function :spssGetSystemString, %i[int pointer], :int
    attach_function :spssGetTextInfo, %i[int pointer], :int
    attach_function :spssGetTimeStamp, %i[int pointer pointer], :int
    attach_function :spssGetValueChar, %i[int double pointer int], :int
    attach_function :spssGetValueNumeric, %i[int double pointer], :int
    attach_function :spssGetVarAlignment, %i[int string pointer], :int
    attach_function :spssGetVarAttributes, %i[int string pointer pointer pointer], :int
    attach_function :spssGetVarCMissingValues, %i[int string pointer pointer pointer pointer], :int
    attach_function :spssGetVarColumnWidth, %i[int string pointer], :int
    attach_function :spssGetVarCompatName, %i[int string pointer], :int
    attach_function :spssGetVarCValueLabel, %i[int string string pointer], :int
    attach_function :spssGetVarCValueLabelLong, %i[int string string pointer int pointer], :int # (int handle, const char* varName, const char* value, char* labelBuff, int lenBuff, int *lenLabel)
    attach_function :spssGetVarCValueLabels, %i[int string pointer pointer pointer], :int
    attach_function :spssGetVarHandle, %i[int string pointer], :int
    attach_function :spssGetVariableSets, %i[int pointer], :int # (int handle, char** varSets)
    attach_function :spssGetVarInfo, %i[int int pointer pointer], :int
    attach_function :spssGetVarLabel, %i[int string pointer], :int
    attach_function :spssGetVarLabelLong, %i[int string pointer int pointer], :int # (int handle, const char* varName, char* labelBuff, int lenBuff, int* lenLabel)
    attach_function :spssGetVarMeasureLevel, %i[int string pointer], :int
    attach_function :spssGetVarNMissingValues, %i[int string pointer pointer pointer pointer], :int
    attach_function :spssGetVarNValueLabel, %i[int string double pointer], :int
    attach_function :spssGetVarNValueLabelLong, %i[int string double pointer int pointer], :int # (int handle, const char* varName, double value, char* labelBuff, int lenBuff, int *lenLabel)
    attach_function :spssGetVarNValueLabels, %i[int string pointer pointer pointer], :int
    attach_function :spssGetVarNames, %i[int pointer pointer pointer], :int
    attach_function :spssGetVarPrintFormat, %i[int string pointer pointer pointer], :int
    attach_function :spssGetVarRole, %i[int string pointer], :int
    attach_function :spssGetVarWriteFormat, %i[int string pointer pointer pointer pointer], :int
    attach_function :spssHostSysmisVal, %i[pointer], :int
    attach_function :spssIsCompatibleEncoding, %i[int pointer], :int # (const int hFile, int* bCompatible)
    attach_function :spssLowHighVal, %i[pointer pointer], :int
    attach_function :spssOpenAppend, %i[string pointer], :int
    attach_function :spssOpenAppendEx, %i[string string pointer], :int
    attach_function :spssOpenRead, %i[string pointer], :int
    attach_function :spssOpenReadEx, %i[string string pointer], :int
    attach_function :spssOpenWrite, %i[string pointer], :int
    attach_function :spssOpenWriteEx, %i[string string pointer], :int # (const char* fileName, const char* password, int* handle)
    attach_function :spssOpenWriteCopy, %i[string string pointer], :int
    attach_function :spssOpenWriteCopyEx, %i[string string string string pointer], :int
    attach_function :spssOpenWriteCopyExFile, %i[string string string pointer], :int
    attach_function :spssOpenWriteCopyExDict, %i[string string string pointer], :int
    attach_function :spssQueryType7, %i[int int pointer], :int
    attach_function :spssReadCaseRecord, %i[int], :int
    attach_function :spssSeekNextCase, %i[int long], :int
    attach_function :spssSetCaseWeightVar, %i[int string], :int # (int handle, const char* varName)
    attach_function :spssSetCompression, %i[int int], :int # (int handle, int compSwitch)
    attach_function :spssSetDateVariables, %i[int int pointer], :int # (int handle, int numofElements, const long* dateInfo)
    attach_function :spssSetDEWFirst, %i[int pointer long], :int # (const int handle, const void* pData, const long nBytes)
    attach_function :spssSetDEWGUID, %i[int string], :int # (const int handle, const char* asciiGUID)
    attach_function :spssSetDEWNext, %i[int pointer long], :int # (const int handle, const void* pData, const long nBytes)
    attach_function :spssSetFileAttributes, %i[int pointer pointer int], :int # (int handle, const char** attribNames, const **attribText, const int nAttributes)
    attach_function :spssSetIdString, %i[int string], :int # (int handle, const char* id)
    attach_function :spssSetInterfaceEncoding, %i[int], :int # (const int iEncoding)
    attach_function :spssSetLocale, %i[int string], :string # (const int iCategory, const char* pszLocale)
    attach_function :spssSetMultRespDefs, %i[int string], :int # (const int handle, const char* mrespDefs)
    attach_function :spssSetTempDir, %i[string], :int # (const char* dirName)
    attach_function :spssSetTextInfo, %i[int string], :int # (const int handle, const char* textInfo)
    attach_function :spssSetValueChar, %i[int double string], :int # (const int handle, const double varHandle, const char* value)
    attach_function :spssSetValueNumeric, %i[int double double], :int # (const int handle, const double varHandle, double value)
    attach_function :spssSetVarAlignment, %i[int string int], :int # (const int handle, const char* varName, int alignment)
    attach_function :spssSetVarAttributes, %i[int string pointer pointer int], :int # (const int handle, const char* varName, const char** attribNames, const char** attribValues, const int nAttributes)
    attach_function :spssSetVarCMissingValues, %i[int string int string string string], :int # (const int handle, const char* varName, const int missingFormat, const char* missingVal1, const char* missingVal2, const char* missingVal3)
    attach_function :spssSetVarColumnWidth, %i[int string int], :int # (const int handle, const char* varName, int columnWidth)
    attach_function :spssSetVarCValueLabel, %i[int string string string], :int # (const int handle, const char* varName, const char* value, const char* label)
    attach_function :spssSetVarCValueLabels, %i[int string pointer pointer int], :int # (const int handle, const char* varName, const char** values, const char** labels, int numLabels)
    attach_function :spssSetVarLabel, %i[int string string], :int # (const int handle, const char* varName, const char* varLabel)
    attach_function :spssSetVarMeasureLevel, %i[int string int], :int # (const int handle, const char* varName, int measureLevel)
    attach_function :spssSetVarNMissingValues, %i[int string int double double double], :int # (const int handle, const char* varName, const int missingFormat, double missingVal1, double missingVal2, double missingVal3)
    attach_function :spssSetVarNValueLabel, %i[int string double string], :int # (const int handle, const char* varName, double value, const char* label)
    attach_function :spssSetVarNValueLabels, %i[int pointer int pointer pointer int], :int # (const int handle, const char** varNames, int numVars, const double* values, const char** labels, int numLabels)
    attach_function :spssSetVarName, %i[int string int], :int # (const int handle, const char* varName, int varLength)
    attach_function :spssSetVarPrintFormat, %i[int string int int int], :int # (const int handle, const char* varName, int printType, int printDec, int printWid)
    attach_function :spssSetVarRole, %i[int string int], :int # (const int handle, const char* varName, int varRole)
    attach_function :spssSetVarWriteFormat, %i[int string int int int], :int # (const int handle, const char* varName, int printType, int printDec, int printWid)
    attach_function :spssSetVariableSets, %i[int string], :int # (const int handle, const char* varSets)
    attach_function :spssSysmisVal, %i[], :double
    attach_function :spssValidateVarname, %i[string], :int # (const char* varName)
    attach_function :spssWholeCaseIn, %i[int pointer], :int # (const int handle, char* caseRec)
    attach_function :spssWholeCaseOut, %i[int pointer], :int # (int handle, const char* caseRec)
    # rubocop:enable Layout/LineLength
  end
end
