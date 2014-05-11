# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  parent_id       :string(255)
#  depth           :integer          default(0), not null
#  order_in_parent :integer          default(0), not null
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Category do

  describe ".save(create)" do

    describe "without name" do

      subject { Category.new(parent_id: nil, depth: 0, order_in_parent: 0).save }

      it { should be_false }

    end # "without name"

    describe "without parent_id, depth and order_in_parent" do

      subject { Category.create(name: "sample") }

      it { Category.new(name: "sample").save.should be_true }

      its(:parent_id)       { should == Category.root_category.id }
      its(:depth)           { should == 1 }
      its(:order_in_parent) { should == 0 }

    end # "without parent_id, depth and order_in_parent"

    describe "set value automatically even though manually setting" do

      subject { Category.create(name: "sample", depth: 100, order_in_parent: 100) }

      its(:depth)           { should == 1 }
      its(:order_in_parent) { should == 0 }

    end # "set values automatically even though manually setting"

    describe "increase new category's" do

      describe "depth when new category is some category's child" do

        let!(:first) { Category.create(name: "first") }
        let!(:child) { Category.create(name: "child", parent: first) }

        it { child.depth.should == first.depth + 1 }

      end

      describe "order_in_parent when new category is some category's sibling" do

        let!(:first)  { Category.create(name: "first",  parent: subject) }
        let!(:second) { Category.create(name: "second", parent: subject) }

        it { second.order_in_parent.should == first.order_in_parent + 1 }

      end

    end # "increase new category's"

  end

  describe ".hierarchy_categories" do

    it "create and return root if categories count is 0" do

      categories = Category.hierarchy_categories(:all)

      categories.should have(1).category
      categories.first.should == Category.root_category

    end

  end # ".hierarchy_categories"

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

    let(:root) { Category.root_category }

    it "if category's parent not exist, parent_id must be root" do
      child11.update(parent_id: "")
      child11.parent_id.should == Category.root_category.id
    end

    describe ".hierarchy_categories" do # and get_hierarchy_categories

      it "is correct" do
        Category.hierarchy_categories(:all).should have(16).categories

        Category.hierarchy_categories(root1[:id]).should have(3).categories
        Category.hierarchy_categories(root2[:id]).should have(4).categories
        Category.hierarchy_categories(root3[:id]).should have(5).categories

        Category.hierarchy_categories(child11[:id]).should have(0).category
        Category.hierarchy_categories(child21[:id]).should have(2).categories
        Category.hierarchy_categories(child31[:id]).should have(3).categories
      end

      it "is correct with except_ids" do
        Category.hierarchy_categories(:all).should have(16).categories

        Category.hierarchy_categories(:all, [root3.id]).should have(10).categories
        Category.hierarchy_categories(:all, [root2.id]).should have(11).categories
        Category.hierarchy_categories(:all, [root1.id]).should have(12).categories
      end

    end # ".hierarchy_categories"

    describe ".up" do

      describe "up category and down above category" do

        it { expect { child12.up }.to change { child12.order_in_parent                }.from(1).to(0) }
        it { expect { child12.up }.to change { Category.find(child11).order_in_parent }.from(0).to(1) }

        it do
          expect {
            child12.delete
            child13.up
          }.to change {
            child13.order_in_parent
          }.from(2).to(0) 
        end

      end

      describe "no up because already top" do

        it { expect { child11.up }.not_to change { child11.order_in_parent } }
        it { expect { root.up    }.not_to change { root.order_in_parent    } }

      end

    end # ".up"

    describe ".down" do

      describe "down category and up below category" do
        
        it { expect { child12.down }.to change { child12.order_in_parent                }.from(1).to(2) }
        it { expect { child12.down }.to change { Category.find(child13).order_in_parent }.from(2).to(1) }

      end

      describe "no down because already bottom" do

        it { expect { child13.down }.not_to change { child13.order_in_parent } }
        it { expect { root.down    }.not_to change { root.order_in_parent    } }

      end # "no down order_in_parent"

    end # ".down"

    describe ".descendants_writings" do

      let(:user) { FactoryGirl.create(:user) }

      it do
        Writing.create(title: "sample1", content: "content", user_id: user.id, category_id: root1.id)
        Writing.create(title: "sample2", content: "content", user_id: user.id, category_id: child11.id)
        Writing.create(title: "sample3", content: "content", user_id: user.id, category_id: child12.id)
        Writing.create(title: "sample4", content: "content", user_id: user.id, category_id: child13.id)

        root1.should have(1).writing
        root1.descendants_writings.should have(4).writings
      end

    end

    describe ".ancestors_and_me" do

      it "should be [first_depth_category, ... , parent, me]" do
        categories = child31111.ancestors_and_me

        categories.should have(5).categories
        categories.first.should == root3
      end

      it "of first depth category should be [first_depth_category]" do
        categories = root1.ancestors_and_me

        categories.should have(1).category
        categories.first.should == root1
      end

      describe "set except one and not set top category should be equal result that not set except one" do

        it "should be expected" do
          categories = child31111.ancestors_and_me(:root, true)

          categories.should have(5).categories
          categories.first.should == root3
        end

        it "should be expected" do
          categories = root1.ancestors_and_me(:root, true)

          categories.should have(1).category
          categories.first.should == root1
        end

      end

      describe "of root" do

        it "should be [root]" do
          categories = root.ancestors_and_me

          categories.should have(1).category
          categories.first.should == root
        end

        it "setting except top should be []" do
          categories = root.ancestors_and_me(:root, true)

          categories.should be_empty
        end

      end

      describe "set top category" do

        it "should be [top_category, ... , parent, me]" do
          categories = child31111.ancestors_and_me(child311)

          categories.should have(3).categories
          categories.first.should == child311
        end

        it "to child or invalid category should be equal result that not set top category"do
          child311.ancestors_and_me(child31111).should == child311.ancestors_and_me
        end

        it "and set except top should be [top_child_category, ... , parent, me]" do
          categories = child31111.ancestors_and_me(child311, true)

          categories.should have(2).categories
          categories.first.should == child31111.parent
        end

      end

    end

    describe ".update" do

      describe "change target's" do

        describe "depth" do

          it { expect { child11.update(parent: root2)  }.not_to change { child11.depth    } }
          it { expect { child211.update(parent: root3) }.to     change { child211.depth   }.to(root3.depth + 1) }
          it { expect { child31111.update(parent: nil) }.to     change { child31111.depth }.to(1) }

        end

        describe "order_in_parent" do

          it { expect { child31111.update(parent: child211) }.not_to change { child31111.order_in_parent } }
          it { expect { child11.update(parent: root2)       }.to     change { child11.order_in_parent    }.to(2) }
          it { expect { child211.update(parent: root3)      }.to     change { child211.order_in_parent   }.to(2) }

        end # "change category's"

        describe "children's depth" do

          it { expect { child31.update(parent: root1)   }.not_to change { child31.children.first.depth } }
          it { expect { child21.update(parent: child11) }.to     change { child21.children.first.depth }.to(child11.depth + 2) }

        end # "change category's children's"

        describe "sibling's order_in_parent" do

          it { expect { child21.update(parent: root1) }.to change { Category.find(child22).order_in_parent }.from(1).to(0) }

        end # "change category's sibling's"

      end

      describe "is impossible when make circular categories" do

        it { child31.update(parent: child31111).should be_false }

      end

    end # ".update"

    describe ".destroy" do

      describe "is impossble" do

        describe "when category have children" do

          it { root1.destroy.should   be_false }
          it { child11.destroy.should be_true }
          it { child21.destroy.should be_false }
          it { child31.destroy.should be_false }

        end

        describe "when category have writings" do
          let(:user) { FactoryGirl.create(:user) }
          before { Writing.create(title: "sample", content: "this is sample", user_id: user.id, category_id: child11.id) }
          
          it { child11.destroy.should be_false }

        end

      end # "is impossble"

    end # ".destroy"

  end # "in hierarchy categories,"

  describe "root category" do

    let!(:default) { Category.create(name: "default") }
    let!(:root   ) { Category.root_category }

    it { root.root?.should be_true }

    describe ".update" do

      describe "parent" do

        it { root.update(parent_id: default.id).should be_false }
        it { root.update(parent_id: 0).should be_false }

      end

      describe "name" do
      
        it { root.update(name: "wtf").should be_true }

      end

    end # ".update"

    describe ".destroy" do

      it { root.destroy.should be_false }

    end # ".destroy"

  end # 'root category'

end
