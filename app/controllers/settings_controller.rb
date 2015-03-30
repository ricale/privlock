class SettingsController < ApplicationController
  before_action :authenticate_user!

  # PATCH/PUT /settings/1
  def update
    @setting = Setting.find(params[:id])
    @licenses = Ccl.all

    @tab = "general"

    if @setting.update(setting_params.merge(active: true))
      redirect_to admin_general_path, notice: 'setting was successfully updated.'
    else
      render 'admin/general', layout: 'layouts/admin'
    end
  end


  private

  def setting_params
    params.require(:setting).permit(:title, :number_of_writing, :ccl_id, :author_name, :author_email)
  end
end
