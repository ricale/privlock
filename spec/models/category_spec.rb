require 'spec_helper'

describe Category do

  describe ".create" do

    describe "raise error without" do

      it "name" do
        expect {

          Category.create!(
            parent_id:       nil,
            depth:           0,
            order_in_parent: 0
          )

        }.to raise_error {
          ActiveRecord::RecordInvalid
        }
      end

    end # "raise error when save without"

    describe "raise no error without" do

      it "parent_id" do
        expect {

          Category.create!(
            name:            "sample",
            depth:           0,
            order_in_parent: 0
          )

        }.not_to raise_error
      end

      it "depth" do
        expect { 

          Category.create!(
            name:            "sample",
            parent_id:       nil,
            order_in_parent: 0
          )

        }.not_to raise_error
      end

      it "order_in_parent" do
        expect {

          Category.create!(
            name:      "sample",
            parent_id: nil,
            depth:     0
          )

        }.not_to raise_error
      end

    end # "raise no error without"

    describe "set automatically first category's" do

      let(:first) { Category.new(name: "sample", parent_id: nil) }

      describe "depth" do

        it "to 1" do
          first.save
          first.depth.should == 1
        end

        it "to 0 even though manually setting depth" do
          first.depth = 100
          first.save
          first.depth.should == 1
        end

      end

      describe "order_in_parent" do

        it "to 0" do
          first.save
          first.order_in_parent.should == 0
        end

        it "to 0 even though manually setting order_in_parent" do
          first.order_in_parent = 100
          first.save
          first.order_in_parent.should == 0
        end

      end

    end # "set automatically first category's"

    describe "auto increase new category's" do

      let(:default) { Category.create(name: "default") }

      it "depth when new category is some category's child" do
        default.depth.should == 1

        child = Category.create(name: "child", parent: default)
        grand_child = Category.create(name: "grand_child",  parent: child)

        child.depth.should       == default.depth + 1
        grand_child.depth.should == child.depth + 1
      end

      it "order_in_parent when new category is some category's sibling" do
        default.order_in_parent.should == 0

        second = Category.create(name: "second")
        
        second.order_in_parent.should == default.order_in_parent + 1

        first_child  = Category.create(name: "first_child", parent: default)
        second_child = Category.create(name: "second_child", parent: default)

        first_child.order_in_parent.should  == 0
        second_child.order_in_parent.should == first_child.order_in_parent + 1
      end

    end # "auto increase new category's"

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
    let!(:child32)    { Category.create(name: "child32",    parent: root3) }

    it "if category's parent not exist, parent_id must be nil" do
      child11.update(parent_id: "")
      child11.parent_id.should == Category.find_by(parent_id: nil).id
    end

    describe ".hierarchy_categories" do

      it "is correct" do
        categories = Category.hierarchy_categories(:all)
        categories.count.should == 16

        categories = Category.hierarchy_categories(root1[:id])
        categories.count.should == 3

        categories = Category.hierarchy_categories(root2[:id])
        categories.count.should == 4

        categories = Category.hierarchy_categories(root3[:id])
        categories.count.should == 5

        categories = Category.hierarchy_categories(child11[:id])
        categories.count.should == 0

        categories = Category.hierarchy_categories(child21[:id])
        categories.count.should == 2

        categories = Category.hierarchy_categories(child31[:id])
        categories.count.should == 3
      end

      it "is correct with except_ids" do
        categories = Category.hierarchy_categories(:all)
        categories.count.should == 16

        categories = Category.hierarchy_categories(:all, [root3.id])
        categories.count.should == 10

        categories = Category.hierarchy_categories(:all, [root2.id])
        categories.count.should == 11

        categories = Category.hierarchy_categories(:all, [root1.id])
        categories.count.should == 12
      end
    end

    describe ".up" do

      it "up order_in_parent" do
        expect {
          child12.up

        }.to change {
          child12.order_in_parent
        }.from(1).to(0)

        Category.find_by(name: "child11").order_in_parent.should == 1
      end

      describe "no up order_in_parent" do

        it "if order_in_parent is top already" do
          expect {
            child11.up

          }.not_to change {
            child11.order_in_parent
          }
        end

        it "if parent_id is nil" do
          expect {
            root3.up

          }.not_to change {
            root3.order_in_parent
          }
        end

      end

    end

    describe ".down" do

      it "down order_in_parent" do
        expect {
          child12.down

        }.to change {
          child12.order_in_parent
        }.from(1).to(2)

        Category.find_by(name: "child13").order_in_parent.should == 1
      end

      describe "no down order_in_parent" do

        it "if order_in_parent is bottom already" do
          expect {
            child13.down

          }.not_to change {
            child13.order_in_parent
          }
        end

        it "if parent_id is nil" do
          expect {
            root1.down

          }.not_to change {
            root1.order_in_parent
          }
        end

      end

    end

    describe "change category's" do

      it "depth when parent is changed" do
        expect {
          child11.update(parent: root2)

        }.not_to change {
          child11.depth
        }

        expect {
          child211.update(parent: root3)

        }.to change {
          child211.depth
        }.from(child21.depth + 1).to(root3.depth + 1)

        expect {
          child31111.update(parent: nil)

        }.to change {
          child31111.depth
        }.from(child3111.depth + 1).to(1)
      end

      it "order_in_parent when parent is changed" do
        child11.update(parent: root2)
        child11.order_in_parent.should == 2

        child211.update(parent: root3)
        child211.order_in_parent.should == 2

        expect {
          child31111.update(parent: child211)

        }.not_to change {
          child31111.order_in_parent
        }
      end

    end

    describe "change category's children's" do

      it "depth when parent of category is changed" do
        expect {
          child21.update(parent: child11)

        }.to change {
          child21.children.first.depth
        }.from(root2.depth + 2).to(child11.depth + 2)

        expect {
          child31.update(parent: root1)

        }.not_to change {
          child31.children.first.depth
        }
      end

    end

    describe "change category's sibling's" do

      it "order_in_parent when parent of category is changed" do
        child22.order_in_parent.should == 1

        child21.update(parent: root1)

        Category.find_by(name: "child22").order_in_parent.should == 0
      end

    end

    it "raise error when make circular categories" do
      child31.parent = child31111
      child31.save.should be_false
    end

  end

end
