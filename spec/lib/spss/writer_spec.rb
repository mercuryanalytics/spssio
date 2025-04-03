# frozen_string_literal: true

require "spssio"
require "tempfile"

RSpec.describe SPSS::Writer do
  subject { described_class.new(savfile.path) }

  let(:savfile) { Tempfile.new(["spssio", ".sav"]) }

  after do
    subject.close
  end

  specify do # rubocop:disable RSpec/ExampleLength
    pending "work in progress"
    subject.compression = :standard
    expect(subject.compression).to eq :standard

    subject.add_variable("RID")
    subject.add_variable("InterviewingLocation", "InterviewingLocation. Location:")
    subject.value_labels("InterviewingLocation",
                         1.0 => "Las Vegas (Ballys)",
                         2.0 => "Orlando (Media Center)",
                         4.0 => "Las Vegas 2 (Flamingo)",
                         5.0 => "Las Vegas 3 (Golden Nugget)")
    subject.add_variable("Comment", 64)

    records = [
      { "RID" => 1, "InterviewingLocation" => "Orlando (Media Center)", "Comment" => "This is a test" },
      { "RID" => 2, "InterviewingLocation" => "Las Vegas (Ballys)", "Comment" => "This is only a test" }
    ]
    records.each do |r|
      r.each do |k, v|
        subject.store(k, v)
      end
    end

    # add variables
    # set variable attributes
    # loop through cases
    #   set values
    #   commit case
    # close
  end
end
