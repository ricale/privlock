class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def categories_for_select_box(parent_categories)
    [["none", nil]].concat(parent_categories.map do |parent|
      [parent.name, parent.id]
    end)
  end
end
