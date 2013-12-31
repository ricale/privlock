require 'spec_helper'

feature "WritingController", type: :feature do

  before do
    User.create(email: "test@for.test", password: "12341234");
  end

  after do
    User.delete_all
    Writing.delete_all
    Category.delete_all
  end


  describe "GET new_writing_path" do
    describe "with no session" do

      scenario "should be moved login page" do
        visit new_writing_path
        current_path.should == new_user_session_path
      end

    end

    describe "with session" do

      before do
        login
        visit new_writing_path
      end

      scenario "should be expected" do
        within("#new_writing") do
          fill_in 'Title', with: 'sample'
          fill_in 'Content', with: 'sample'
        end

        click_button 'Create'

        writing = Writing.order(created_at: :desc).first
        current_path.should == show_path(writing)
      end

      scenario "should be not moved if no fill all needed field" do
        within("#new_writing") do
          fill_in 'Content', with: 'sample'
        end

        click_button 'Create'

        page.should have_selector("#error_explanation")
      end

    end

  end



  describe "GET edit_writing_path" do

    scenario do
      pending
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