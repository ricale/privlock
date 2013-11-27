require 'spec_helper'

describe User do
  
  describe "admin" do

    subject { User.create(email: "test@for.test", password: "passwrod") }

    it { User.count == 1 }

    describe "is first registrated user" do

      it { should be_admin }

    end

    describe "is never destroyed" do

      it { subject.destroy.should be_false }
      
    end

  end

end
