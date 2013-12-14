# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean          default(FALSE)
#

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
