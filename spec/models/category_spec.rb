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

      it "parent_id and parent_id should be nil" do
        category = Category.new(
          name: "sample",
          family: 0,
          depth: 0,
          order_in_parent: 0
        )

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }

        category.parent_id.should be_nil
      end

      it "famaily and family should be 0" do
        category = Category.new(
          name: "sample",
          parent_id: 0,
          depth: 0,
          order_in_parent: 0
        )

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }

        category.family.should == 0
      end

      it "depth and depth should be 0" do
        category = Category.new(
          name: "sample",
          parent_id: nil,
          family: 0,
          order_in_parent: 0
        )

        expect { category.save! }.not_to raise_error {
          ActiveRecord::RecordInvalid
        }

        category.depth.should == 0
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

        category.order_in_parent.should == 0
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
      default.family.should == 0

      second_category = Category.create(name: "second")
      third_category  = Category.create(name: "third")

      second_category.family.should == default.family + 1
      third_category.family.should  == second_category.family + 1
    end

    it "depth when new category is some category's child" do
      default.depth.should == 0

      child = Category.create(name: "child", parent: default)
      grand_child = Category.create(name: "grand_child",  parent: child)

      child.depth.should == default.depth + 1
      grand_child.depth.should == child.depth + 1
    end

    it "order_in_parent when new category is some category's sibling" do
      default.order_in_parent.should == 0

      first_child  = Category.create(name: "first_child", parent: default)
      second_child = Category.create(name: "second_child", parent: default)
      third_child  = Category.create(name: "third_child", parent: default)

      first_child.order_in_parent.should == 0
      second_child.order_in_parent.should  == first_child.order_in_parent + 1
      third_child.order_in_parent.should == second_child.order_in_parent + 1
    end

  end

  describe "in hierarchy categories," do
    let!(:root1) { Category.create(name: "root1") }
    let!(:root2) { Category.create(name: "root2") }
    let!(:root3) { Category.create(name: "root3") }
    let!(:child11) { Category.create(name: "child11", parent: root1) }
    let!(:child12) { Category.create(name: "child12", parent: root1) }
    let!(:child13) { Category.create(name: "child13", parent: root1) }
    let!(:child21)  { Category.create(name: "child21",  parent: root2) }
    let!(:child211) { Category.create(name: "child211", parent: child21) }
    let!(:child212) { Category.create(name: "child212", parent: child21) }
    let!(:child22)  { Category.create(name: "child22",  parent: root2) }
    let!(:child31)    { Category.create(name: "child31",    parent: root3) }
    let!(:child311)   { Category.create(name: "child311",   parent: child31) }
    let!(:child3111)  { Category.create(name: "child3111",  parent: child311) }
    let!(:child31111) { Category.create(name: "child31111", parent: child3111) }

    it "descendant's count is correct" do
      categories = Category.hierarchy_categories(nil)
      categories.count.should == 14

      categories = Category.hierarchy_categories(root1[:id])
      categories.count.should == 3

      categories = Category.hierarchy_categories(root2[:id])
      categories.count.should == 4

      categories = Category.hierarchy_categories(root3[:id])
      categories.count.should == 4

      categories = Category.hierarchy_categories(child11[:id])
      categories.count.should == 0

      categories = Category.hierarchy_categories(child21[:id])
      categories.count.should == 2

      categories = Category.hierarchy_categories(child31[:id])
      categories.count.should == 3
    end

    describe "change category's" do

      it "family when parent's family of category is changed" do

      end

      it "depth when parent's depth of category is changed" do

      end

    end

    describe "change category's children's" do

      it "family when family of category is changed" do

      end

      it "depth when family of category is changed" do
        
      end

    end

  end

end
