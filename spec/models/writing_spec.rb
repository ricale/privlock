require 'spec_helper'

describe Writing do

  describe ".create" do

    describe "is impossible" do

      describe "without" do

        it "title" do
          writing = Writing.new(content: "this is just test", category_id: 0)
          writing.save.should be_false
        end

        it "content" do
          writing = Writing.new(title: "test", category_id: 0)
          writing.save.should be_false
        end

        it "category_id" do
          writing = Writing.new(title: "test", content: "this is just test")
          writing.save.should be_false
        end

      end # "without"

      it "when invalid category_id" do
        writing = Writing.new(
          title: "test",
          content: "this is just test",
          category_id: 0
        )

        writing.save.should be_false
      end

    end # "is impossible"

    describe "is success with all" do

      it do
        writing = Writing.new(
          title: "test",
          content: "this is just test",
          category_id: Category.root_category.id
        )

        writing.save.should be_true

      end

    end # "is success with all"

  end # ".create"

end
