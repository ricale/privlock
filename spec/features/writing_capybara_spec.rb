require 'spec_helper'

feature "WritingController", type: :feature do

  before(:all) do
    User.create(email: "test@for.test", password: "12341234");
    10.times.each { FactoryGirl.create(:writing) }
  end

  after(:all) do
    User.delete_all
    Writing.delete_all
    Category.delete_all
  end

  describe "GET writings_path" do

    scenario "works" do
      visit writings_path
      current_path.should == writings_path
    end

    describe "New Writing link" do

      scenario "is not exist with no session" do
        visit writings_path

        page.should have_no_selector("a[href='/new']")
      end

      scenario "is exist with session" do
        login
        visit writings_path

        page.should have_selector("a[href='/new']")
      end

    end

    describe "clicking" do

      describe "writings title link" do

        scenario "works" do
          visit writings_path

          writing = Writing.first
          find("#writing_#{writing.id}").click_link(writing.title)

          current_path.should == writing_path(writing)
        end

      end

      describe "cagetory name link" do

        scenario "works" do
          visit writings_path

          writing = Writing.first
          find("#writing_#{writing.id}").click_link(writing.category.name)

          current_path.should == category_writings_path(writing.category)
        end

      end

      describe "New Writing link" do

        scenario "works, with session" do
          login
          visit writings_path
          click_link 'New Writing'
          current_path.should == new_writing_path
        end

      end

    end

  end

  describe "GET writing_path" do

    scenario "works" do
      writing = Writing.first
      visit writing_path(writing)
      current_path.should == writing_path(writing)
    end

    describe "Edit writing link" do

      scenario "is not exist with no session" do
        writing = Writing.first
        visit writing_path(writing)

        page.should have_no_selector("a[href='/#{writing.id}/edit']")
      end

      scenario "is exist with session" do
        login
        writing = Writing.first
        visit writing_path(writing)

        page.should have_selector("a[href='/#{writing.id}/edit']")
      end

    end

    describe "clicking link of" do

      describe "writings title" do

        scenario "works" do
          writing = Writing.first
          visit writing_path(writing)

          click_link(writing.title)

          current_path.should == writing_path(writing)
        end

      end

      describe "cagetory name" do

        scenario "works" do
          writing = Writing.first
          visit writing_path(writing)

          click_link(writing.category.name)

          current_path.should == category_writings_path(writing.category)
        end

      end

      describe "edit" do

        scenario "works, with session" do
          login
          writing = Writing.first
          visit writing_path(writing)

          click_link('Edit')
          current_path.should == edit_writing_path(Writing.first)
        end
      end

    end

  end



  describe "GET new_writing_path" do

    scenario "not works, move to login page" do
      visit new_writing_path
      current_path.should == new_user_session_path
    end

    scenario "works, with session" do
      login
      visit new_writing_path
      current_path.should == new_writing_path
    end

    describe "create writing" do

      it "not works, with invalid form" do
        create_writing

        page.should have_selector('#new_writing')
      end

      it "works, with valid form" do
        create_writing do
          within "#new_writing" do
            fill_in "Title",   with: "Sample"
            fill_in "Content", with: "This is sample!"
          end
        end

        current_path.should == writing_path(Writing.last)
      end

      def create_writing
        login
        visit new_writing_path

        yield if block_given?

        click_button "Create Writing"
      end

    end

  end



  describe "GET edit_writing_path" do

    scenario "not works, move to login page" do
      visit edit_writing_path(Writing.first)
      current_path.should == new_user_session_path
    end

    scenario "works, with session" do
      login
      visit edit_writing_path(Writing.first)
      current_path.should == edit_writing_path(Writing.first)
    end

    describe "update writing" do

      it "not works, with invalid form" do
        update_writing do
          within ".edit_writing" do
            fill_in "Title",   with: ""
            fill_in "Content", with: ""
          end
        end

        page.should have_selector('.edit_writing')
      end

      it "works, with valid form" do
        update_writing

        current_path.should == writing_path(Writing.first)
      end

      def update_writing
        login
        visit edit_writing_path(Writing.first)

        yield if block_given?

        click_button "Update Writing"
      end

    end

  end

  def login
    visit new_user_session_path

    within '#new_user' do
      fill_in 'Email',    with: "test@for.test"
      fill_in 'Password', with: "12341234"
    end

    click_button 'Sign in'
  end

end