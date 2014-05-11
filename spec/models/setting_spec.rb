require 'spec_helper'

describe Setting do
  describe ".save(create)" do

    let(:active) { false }
    let(:title) { "my_blog" }
    let(:number_of_writing)   { 5 }

    describe "without" do

      describe "active" do
        it { Setting.new(title: title, number_of_writing: number_of_writing).save.should be_true }
      end

      describe "title" do
        it { Setting.new(active: active, number_of_writing: number_of_writing).save.should be_true }
      end

      describe "number_of_writing" do
        it { Setting.new(active: active, title: title).save.should be_true }
      end

    end

    describe "with" do

      describe "all parameters" do
        it { FactoryGirl.build(:setting).save.should be_true }
      end

    end

  end

  describe ".update" do

    let(:setting)  { FactoryGirl.create(:setting) }

    describe "active" do
      it { setting.update(active: false).should be_false }
      it { setting.update(active: true).should be_true }
      it { setting.update(active: nil).should be_true }
    end

    describe "title" do
      it { setting.update(title: "").should be_false }
      it { setting.update(title: "Anything but Nothing").should be_true }
    end

    describe "number_of_writing" do
      it { setting.update(number_of_writing: -1).should be_false }
      it { setting.update(number_of_writing: 0).should be_false }
      it { setting.update(number_of_writing: 21).should be_false }
      it { setting.update(number_of_writing: nil).should be_true }
      it { setting.update(number_of_writing: 20).should be_true }
      it { setting.update(number_of_writing: 1).should be_true }
    end

  end

  describe ".destroy" do

  end

  ## TODO
  # be_active
  # be_inactive_existing_active_setting_if_necessary
end
