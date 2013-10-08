require 'spec_helper'

describe Writing do

  describe "raise error when save without" do

    it "title" do
      writing = Writing.new(content: "smaples")
      expect { writing.save! }.to raise_error {
        ActiveRecord::RecordInvalid
      }
    end

    it "content" do
      writing = Writing.new(title: "samples")
      expect { writing.save! }.to raise_error {
        ActiveRecord::RecordInvalid
      }
    end

  end

end
