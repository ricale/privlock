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

  let!(:writing)  { FactoryGirl.create(:writing) }
  let!(:category) { FactoryGirl.create(:category) }
  let!(:user)     { FactoryGirl.create(:user) }

  let!(:normal_user) { FactoryGirl.create(:normal_user) }

  describe ".save(create)" do
    let(:title)   { "title" }
    let(:content) { "content" }

    let(:invalid_category_id) { "invalid_category_id" }
    let(:invalid_user_id)     { "invalid_user_id" }

    describe "without one" do
      it { Writing.new(              content: content, category_id: category.id, user_id: user.id).save.should be_false }
      it { Writing.new(title: title,                   category_id: category.id, user_id: user.id).save.should be_false }
      it { Writing.new(title: title, content: content,                           user_id: user.id).save.should be_false }
      it { Writing.new(title: title, content: content, category_id: category.id                  ).save.should be_false }
    end # "without"

    describe "with" do

      describe "all parameters" do
        it { Writing.new(title: title, content: content, category_id: category.id, user_id: user.id).save.should be_true }
      end

      describe "invalid category_id" do
        it { Writing.new(title: title, content: content, category_id: invalid_category_id, user_id: user.id).save.should be_false }
      end

      describe "invalid user_id" do
        it { Writing.new(title: title, content: content, category_id: category.id, user_id: invalid_user_id).save.should be_false }
      end

      describe "that valid but not admin" do
        it { Writing.new(title: title, content: content, category_id: category.id, user_id: normal_user.id).save.should be_false }
      end

    end 

  end # ".create"

  describe ".update" do

    describe "update title or content or category_id" do
      it { writing.update(title: "new title").should be_true }
      it { writing.update(content: "new content").should be_true }
      it { writing.update(category_id: FactoryGirl.create(:category).id).should be_true }

      describe "to nil or invalid" do
        it { writing.update(title: nil).should be_false }
        it { writing.update(content: nil).should be_false }
        it { writing.update(category_id: nil).should be_false }
        it { writing.update(category_id: -1).should be_false }
      end
    end

    describe "update user_id" do
      it { writing.update(user_id: FactoryGirl.create(:user).id).should be_false }
    end
  end

  describe ".destroy" do

    it { writing.destroy.should be_true }

  end

  describe "scopes or method" do

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

    describe "last_comment_updated_at" do
      let(:comment1) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample1") }
      let(:comment2) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample2") }
      let(:comment3) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample3") }
      let(:comment4) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample4") }
      let(:comment5) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample5") }
      let(:comment6) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample6") }

      before {
        10.times {  }
      }

      it "should be expected" do
        comment6.update(content: "test")
        writing.last_comment_updated_at.strftime("%Y%m%d%H%M%S").should == comment6.updated_at.strftime("%Y%m%d%H%M%S")
        comment1.update(content: "test")
        writing.last_comment_updated_at.strftime("%Y%m%d%H%M%S").should == comment1.updated_at.strftime("%Y%m%d%H%M%S")
      end

    end

  end

end
