# frozen_string_literal: true

require "spssio"
require "tempfile"
require "csv" # TODO: remove

RSpec.describe SPSS::Reader do
  subject { described_class.new(savfile) }

  let(:savfile) { file_fixture("MA2912GSSONE.sav").to_s }
  let(:n_vars) { 225 }
  let(:n_cases) { 1009 }

  after do
    subject.close
  end

  it "has the variable names", :aggregate_failures do
    expect(subject.variable_names.size).to eq n_vars
    expect(subject.variable_names).to include("Respondent_Serial", "QC_M2MCONTACT", "StraightLinerCount1")
  end

  it "has the number of cases" do
    expect(subject.number_of_cases).to eq n_cases
  end

  it "enumerates the cases" do
    expect { |b| subject.each(&b) }.to yield_control.exactly(n_cases).times
  end

  it "can return a variable handle", :aggregate_failures do
    expect(subject.variable_handle("RID")).to be_a Numeric
    expect(subject.variable_handle("bad_var")).to be_nil
  end

  it "can return the labels for a variable" do
    expect(subject.label("RID")).to eq "RID"
  end

  it "can return the labels for a variable's values", :aggregate_failures do
    expect { subject.values("RID") }.to raise_error SPSS::Warning, "Warning no_labels"
    expect(subject.values("Comp")).to include(1.0 => "Started", 2.0 => "Completed", 3.0 => "Screen Out",
                                              4.0 => "Over Quota", 5.0 => "M2M Data Error",
                                              6.0 => "Respondent Marked Bad", 7.0 => "Script Error")
  end

  context "when at the first record" do
    let(:enum) { subject.each }

    before do
      enum.next
    end

    it "yields a case record" do
      expect(enum.next).to respond_to(:each)
    end

    it "can enumerate the values" do
      expect(enum.next.to_a[8..12]).to eq [1491.0, "MA2912GSSONE", "Active", 24.85, 7.0]
    end

    it "can fetch variable values", :aggregate_failures do
      expect(subject.fetch("Respondent_Serial")).to eq 84
      expect(subject.fetch("SurveyDuration")).to eq 1326
      expect(subject.fetch("ProjectName")).to eq "MA2912GSSONE"
      expect { subject.fetch("bad_var") }.to raise_error SPSS::Reader::Error, 'No such variable "bad_var"'
    end
  end
end
