require 'spec_helper'

feature "HomeController", type: :feature do

  let(:writing)  { Writing.order(created_at: :desc).first }
  let(:category) { Category.first }

  before(:all) do
    User.create(email: "test@for.test", password: "12341234");
    10.times.each { FactoryGirl.create(:writing) }
  end

  after(:all) do
    User.delete_all
    Writing.delete_all
    Category.delete_all
  end

  # no test pagination
  # because I use gem kaminari for pagination already widely used

  describe "GET index_path" do

    before { visit index_path }

    scenario "should be expected" do
      current_path.should == index_path

      page.should have_selector(".header .title h1")
      page.should have_selector(".writings")
      page.should have_selector(".categories")
      page.should have_no_selector(".main_menu")

      login
      page.should have_selector(".main_menu")
    end

    describe "clicking links" do
      describe "in .main_menu" do
        describe "'new writing'" do

          scenario "should be expected with session" do
            login
            find('.main_menu').click_link('New Writing')
            current_path.should == new_writing_path
          end

          scenario "should be impossible with no session" do
            page.should have_no_selector("a[href='#{new_writing_path}']")
          end

        end

        describe "'categories'" do

          scenario "should be expected with session" do
            login
            find('.main_menu').click_link('Categories')
            current_path.should == categories_path
          end

          scenario "should be impossible with no session" do
            page.should have_no_selector("a[href='#{categories_path}']")
          end

        end
      end

      describe "in .writings" do
        describe "writings title" do

          scenario "should be expected" do
            find("#writing_#{writing.id}").click_link(writing.title)
            current_path.should == show_path(writing)
          end

        end

        describe "cagetory name" do

          scenario "should be expected" do
            find("#writing_#{writing.id}").click_link(writing.category.name)
            current_path.should == category_writings_path(writing.category)
          end

        end

        describe "edit writing" do

          scenario "should be expected with session" do
            login
            first("div#writing_#{writing.id} div.menu").click_link('[E]')
            current_path.should == edit_writing_path(writing)
          end

          scenario "should be impossible with no session" do
            page.should have_no_selector("a[href='#{edit_writing_path(writing)}']")
          end

        end

        describe "delete writing" do

          scenario "should be expected with session" do
            login
            first("div#writing_#{writing.id} div.menu").click_link('[D]')
            current_path.should == index_path
          end

          scenario "should be impossible with no session" do
            page.should have_no_selector("div#writing_#{writing.id} div.menu a[href='#{writing_path(writing)}']")
          end

        end
      end

      describe "in .categories" do
        describe "category name" do

          scenario "should be expected" do
            find('.categories').click_link(category.name)
            current_path.should == category_writings_path(category)
          end

        end
      end
    end

  end

  describe "GET show_path" do

    before { visit show_path(writing) }

    scenario "should be expected" do
      current_path.should == show_path(writing)

      page.should have_selector(".header .title h1")
      page.should have_selector(".writings")
      page.all(".writing").count.should == 1
      page.should have_selector(".categories")
      page.should have_no_selector(".main_menu")

      login
      page.should have_selector(".main_menu")
    end

    describe "clicking links" do
      describe "in .main_menu" do
        describe "'new writing'" do

          scenario "should be expected with session" do
            login
            find('.main_menu').click_link('New Writing')
            current_path.should == new_writing_path
          end

          scenario "should be impossible with no session" do
            page.should have_no_selector("a[href='#{new_writing_path}']")
          end

        end

        describe "'categories'" do

          scenario "should be expected with session" do
            login
            find('.main_menu').click_link('Categories')
            current_path.should == categories_path
          end

          scenario "should be impossible with no session" do
            page.should have_no_selector("a[href='#{categories_path}']")
          end

        end
      end

      describe "in .writings" do
        describe "writings title" do

          scenario "should be expected" do
            find("#writing_#{writing.id}").click_link(writing.title)
            current_path.should == show_path(writing)
          end

        end

        describe "cagetory name" do

          scenario "should be expected" do
            find("#writing_#{writing.id}").click_link(writing.category.name)
            current_path.should == category_writings_path(writing.category)
          end

        end

        describe "edit writing" do

          scenario "should be expected with session" do
            login
            first("div#writing_#{writing.id} div.menu").click_link('[E]')
            current_path.should == edit_writing_path(writing)
          end

          scenario "should be impossible with no session" do
            page.should have_no_selector("a[href='#{edit_writing_path(writing)}']")
          end

        end

        describe "delete writing" do

          scenario "should be expected with session" do
            login
            first("div#writing_#{writing.id} div.menu").click_link('[D]')
            current_path.should == index_path
          end

          scenario "should be impossible with no session" do
            page.should have_no_selector("div#writing_#{writing.id} div.menu a[href='#{writing_path(writing)}']")
          end

        end
      end

      describe "in .categories" do

        describe "category name" do

          scenario "should be expected" do
            find('.categories').click_link(category.name)
            current_path.should == category_writings_path(category)
          end

        end
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