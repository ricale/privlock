# == Schema Information
#
# Table name: comments
#
#  id            :integer          not null, primary key
#  writing_id    :integer          not null
#  email         :string(255)
#  name          :string(255)
#  password_hash :string(255)
#  user_id       :integer
#  content       :text             not null
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Comment do

  let!(:writing) { FactoryGirl.create(:writing) }
  let!(:user)    { FactoryGirl.create(:user) }
  let(:comment)  { FactoryGirl.create(:comment) }

  let(:name)     { "tester" }
  let(:password) { "test" }
  let(:content)  { "sample content" }

  describe ".save(create)" do

    let(:email)    { "tester@email.com" }

    let(:invalid_email)   { "this is not email" }
    let(:invalid_user_id) { "what the" }

    describe "without" do

      describe "writing_id" do
        it { Comment.new(email: email, name: name, password: password, user_id: user.id, content: content).save.should be_false }
      end

      describe "content" do
        it { Comment.new(writing_id: writing.id, email: email, name: name, password: password, user_id: user.id).save.should be_false }
      end

      describe "user_id and one of email, name and password" do
        it { Comment.new(writing_id: writing.id,               name: name, password: password, content: content).save.should be_true }
        it { Comment.new(writing_id: writing.id, email: email,             password: password, content: content).save.should be_false }
        it { Comment.new(writing_id: writing.id, email: email, name: name,                     content: content).save.should be_false }
      end

    end

    describe "with" do

      describe "all parameters" do
        it { FactoryGirl.build(:comment).save.should be_true }
      end

      describe "user_id and without name, email and password" do
        it { Comment.new(writing_id: writing.id, user_id: user.id, content: content).save.should be_true }
      end

      describe "invalid user_id" do

        describe "and valid others" do
          it { Comment.new(writing_id: writing.id, email: email, name: name, password: password, user_id: invalid_user_id, content: content).save.should be_true }
        end

        describe "and valid others without email, name, and password" do
          it { Comment.new(writing_id: writing.id, user_id: invalid_user_id, content: content).save.should be_false }
        end

      end

      describe "invalid email" do

        describe "and valid others without user_id" do
          it { Comment.new(writing_id: writing.id, email: invalid_email, name: name, password: password, content: content).save.should be_false }
        end

        describe "and valid others" do
          it { Comment.new(writing_id: writing.id, email: invalid_email, name: name, password: password, user_id: user.id, content: content).save.should be_true }
        end

      end

    end

  end

  describe ".update" do

    describe "update each others except content" do
      it { comment.update(writing_id: FactoryGirl.create(:writing).id).should be_false }
      it { comment.update(email:      "new_email@new.net").should be_false }
      it { comment.update(name:       "new_tester").should be_false }
      it { comment.update(password:   "new_password").should be_false }
      it { comment.update(user_id:    FactoryGirl.create(:user).id).should be_false }
    end

    describe "update content" do
      it { comment.update(content: "never mind").should be_true }

      describe "to nil or invalid" do
        it { comment.update(content: nil).should be_false }
      end
    end

  end

  describe ".destroy" do

  end

  describe "scope or method" do

    describe "display_name" do

      it "should be expected" do
        has_user_id = Comment.create(writing_id: writing.id, user_id: user.id, content: content)
        has_name    = Comment.create(writing_id: writing.id, name: name, password: password, content: content)

        has_user_id.display_name.should == user.name
        has_name.display_name.should == has_name.name
      end
    end

    describe "last_updated_at" do
      let(:comment1) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample1") }
      let(:comment2) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample2") }
      let(:comment3) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample3") }
      let(:comment4) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample4") }
      let(:comment5) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample5") }
      let(:comment6) { Comment.create(user_id: user.id, writing_id: writing.id, content: "sample6") }

      it "should be expected" do
        comment6.update(content: "test")
        Comment.last_updated_at(writing.id).strftime("%Y%m%d%H%M%S").should == comment6.updated_at.strftime("%Y%m%d%H%M%S")
        comment1.update(content: "test")
        Comment.last_updated_at(writing.id).strftime("%Y%m%d%H%M%S").should == comment1.updated_at.strftime("%Y%m%d%H%M%S")
      end

    end
  end

end
