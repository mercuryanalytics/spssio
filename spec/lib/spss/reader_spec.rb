# frozen_string_literal: true

require "spssio"
require "tempfile"
require "csv" # TODO: remove

RSpec.describe SPSS::Reader do
  # let(:savfile) { File.join("fixtures", "MA2912GSSONE.sav") }
  subject { described_class.new(savfile) }

  let(:savfile) { "sandbox/2018PilotsExamples/Bright Futures/PLTBRF20 Orlando.sav" }
  let(:n_vars) { 327 }
  let(:n_cases) { 206 }

  after do
    subject.close
  end

  it "has the variable names", :aggregate_failures do
    expect(subject.variable_names.size).to eq n_vars
    expect(subject.variable_names).to include("RID", "ShowTitle", "Episode", "Genre")
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
    expect(subject.label("RID")).to eq "RID. Respondent ID"
  end

  it "can return the labels for a variable's values", :aggregate_failures do
    expect(subject.values("RID")).to eq :no_labels
    expect(subject.values("DayOfWeek")).to include(1.0 => "Monday", 2.0 => "Tuesday", 3.0 => "Wednesday",
                                                   4.0 => "Thursday", 5.0 => "Friday", 6.0 => "Saturday",
                                                   7.0 => "Sunday")
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
      expect(enum.next.to_a.take(4)).to eq [25_812.0, "041218", "421", "PLTBRF20"]
    end

    it "can fetch variable values", :aggregate_failures do
      expect(subject.fetch("RID")).to eq 25_817
      expect(subject.fetch("ShowTitle")).to eq "Bright Futures"
      expect { subject.fetch("bad_var") }.to raise_error SPSS::Error, 'No such variable "bad_var"'
    end
  end

  specify do # rubocop:disable RSpec/ExampleLength
    pending "this shouldn't create the leftover file"
    # out = Tempfile.new(["sample", ".csv"])
    CSV.open("test.csv", "wb") do |csv|
      csv << subject.variable_names
      subject.each do |cr|
        csv << cr.to_a
      end
    end
  end

  specify do # rubocop:disable RSpec/ExampleLength
    pending "this shouldn't create the leftover file"
    CSV.open("labels.csv", "wb") do |csv|
      csv << %w[Name Code Label]
      subject.variable_names.each do |name|
        csv << [name, nil, subject.label(name)]
        value_labels = subject.values(name)
        next if value_labels == :no_labels

        value_labels.each do |k, v|
          csv << [nil, k, v]
        end
      end
    end
  end

  specify "this", :aggregate_failures, :not_tested do # rubocop:disable RSpec/ExampleLength
    pending "unknown"

    var_names = subject.variable_names
    expect(var_names).to include(["Respondent_Serial", 0], ["Location", 64], ["Weight", 0])
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
  end
end
