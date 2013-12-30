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

  let!(:writing) { FactoryGirl.create(:writing) }

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

    describe "with category_id" do # before_save is_exist_category?

      describe "that invalid" do

        it { FactoryGirl.build(:invalid_category_id).save.should be_false }

      end

      describe "that valid" do

        it { FactoryGirl.build(:writing).save.should be_true }

      end

    end

  end # ".create"

  describe ".update" do

    describe "without" do

      describe "title" do

        it { writing.update(title: nil).should be_false }

      end

      describe "content" do
        
        it { writing.update(content: nil).should be_false }

      end

      describe "category_id" do
        
        it { writing.update(category_id: nil).should be_false }

      end

    end # "without"

    describe "with category_id" do # before_save is_exist_category?

      describe "that invalid" do

        it { writing.update(category_id: -1).should be_false }

      end

      describe "that valid" do

        it { writing.update(category_id: FactoryGirl.create(:category).id).should be_true }

      end

    end
  end

  describe ".destroy" do

    it { writing.destroy.should be_true }

  end

  describe "scopes or class method" do

    let!(:category1)   { Category.create(name: "category1") }
    let!(:category11)  { Category.create(name: "category1",  parent: category1) }
    let!(:category111) { Category.create(name: "category11", parent: category11) }
    let!(:category112) { Category.create(name: "category12", parent: category11) }
    let!(:category12)  { Category.create(name: "category2",  parent: category1) }
    let!(:category13)  { Category.create(name: "category3",  parent: category1) }

    before {
      3.times { Writing.create(title: "sample", content: "sample", category_id: category1.id) }
      4.times { Writing.create(title: "sample", content: "sample", category_id: category11.id) }
      5.times { Writing.create(title: "sample", content: "sample", category_id: category111.id) }
      6.times { Writing.create(title: "sample", content: "sample", category_id: category112.id) }
      7.times { Writing.create(title: "sample", content: "sample", category_id: category12.id) }
      8.times { Writing.create(title: "sample", content: "sample", category_id: category13.id) }
    }

    describe "in_categories" do

      it "should be expected" do
        Writing.in_categories([category1.id, category111.id]).count.should  == category1.writing.count + category111.writing.count
        Writing.in_categories([category12.id, category13.id]).count.should  == category12.writing.count + category13.writing.count
        Writing.in_categories([category11.id, category112.id]).count.should == category11.writing.count + category112.writing.count
      end

    end

    describe "in_category_tree" do

      it "should be expected" do
        Writing.in_category_tree(category1.id).should   == category1.descendants_writings
        Writing.in_category_tree(category11.id).should  == category11.descendants_writings
        Writing.in_category_tree(category111.id).should == category111.descendants_writings
        Writing.in_category_tree(category112.id).should == category112.descendants_writings
        Writing.in_category_tree(category12.id).should  == category12.descendants_writings
        Writing.in_category_tree(category13.id).should  == category13.descendants_writings
      end

    end

  end

end
