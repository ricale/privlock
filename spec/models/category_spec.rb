require 'spec_helper'

describe Category do

  describe "raise error when save without" do

    it "name" do
      category = Category.new(
        parent_id: nil,
        family: 0,
        depth: 0,
        order_in_parent: 0
      )

      expect { category.save! }.to raise_error {
        ActiveRecord::RecordInvalid
      }
    end

  end # "raise error when save without"

  describe "raise no error when save" do

    describe "without" do

      it "parent_id" do
        category = Category.new(
          name: "sample",
          family: 0,
          depth: 0,
          order_in_parent: 0
        )

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }
      end

      it "famaily" do
        category = Category.new(
          name: "sample",
          parent_id: 0,
          depth: 0,
          order_in_parent: 0
        )

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }
      end

      it "depth" do
        category = Category.new(
          name: "sample",
          parent_id: nil,
          family: 0,
          order_in_parent: 0
        )

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }
      end

      it "order_in_parent" do
        category = Category.new(
          name: "sample",
          parent_id: nil,
          family: 0,
          depth: 0
        )

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }
      end

    end # "without"

    describe "only" do

      it "name" do
        category = Category.new(name: "sample")

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }
      end

      it "name and specific parent_id" do
        category = Category.new(
          name: "sample",
          parent_id: 1
        )

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }
      end

    end # "only"

  end # "raise no error when save"

  describe "auto increase new category's" do
    let(:default) { Category.create(name: "default") }

    it "family when new category is root" do
      default
      second_category = Category.create(name: "second")
      third_category  = Category.create(name: "third")

      default.family.should == 0
      second_category.family.should == default.family + 1
      third_category.family.should  == second_category.family + 1
    end

    it "depth when new category is some category's child" do
      child = Category.create(name: "child", parent: default)
      grand_child = Category.create(name: "grand_child",  parent: child)

      default.depth.should == 0
      child.depth.should == default.depth + 1
      grand_child.depth.should == child.depth + 1
    end

    it "order_in_parent when new category is some category's sibling" do
      first_child  = Category.create(name: "first_child", parent: default)
      second_child = Category.create(name: "second_child", parent: default)
      third_child  = Category.create(name: "third_child", parent: default)

      default.order_in_parent.should == 0
      first_child.order_in_parent.should == 0
      second_child.order_in_parent.should  == first_child.order_in_parent + 1
      third_child.order_in_parent.should == second_child.order_in_parent + 1
    end
  end

end
