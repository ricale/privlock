# == Schema Information
#
# Table name: writings
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  content     :text             not null
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer          not null
#

require 'spec_helper'

describe Writing do

  describe ".save(create)" do

    describe "without" do

      describe "title" do

        it { FactoryGirl.build(:no_title).save.should be_false }

      end

      describe "content" do
        
        it { FactoryGirl.build(:no_content).save.should be_false }

      end

      describe "category_id" do
        
        it { FactoryGirl.build(:no_category_id).save.should be_false }

      end

    end # "without"

    describe "with category_id" do

      describe "that invalid" do

        it { FactoryGirl.build(:invalid_category_id).save.should be_false }

      end

      describe "that valid" do

        it { FactoryGirl.build(:writing).save.should be_true }

      end

    end

  end # ".create"

end
