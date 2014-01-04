require 'spec_helper'

feature "CategoryController", type: :feature do

  before do
    User.create(email: "test@for.test", password: "12341234");
  end

  after do
    User.delete_all
    Writing.delete_all
    Category.delete_all
  end

end