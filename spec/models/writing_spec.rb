require 'spec_helper'

describe Writing do

  describe ".save(create)" do

    describe "without" do

      describe "name" do

        subject { Writing.new(content: "this is just test", category_id: 0).save }

        it { should be_false }

      end

      describe "content" do

        subject { Writing.new(title: "test", category_id: 0).save }
        
        it { should be_false }

      end

      describe "category_id" do

        subject { Writing.new(title: "test", content: "this is just test").save }
        
        it { should be_false }

      end

    end # "without"

    describe "with category_id" do

      describe "that invalid" do
      
        subject { writing = Writing.new(title: "test", content: "this is just test", category_id: 0).save }

        it { should be_false }

      end

      describe "that valid" do

        subject { writing = Writing.new(title: "test", content: "this is just test", category_id: Category.root_category.id).save }

        it { should be_true }

      end

    end

  end # ".create"

end
