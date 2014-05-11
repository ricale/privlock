class SettingsController < ApplicationController
  before_action :authenticate_user!

  # PATCH/PUT /settings/1
  def update
    @setting = Setting.find(params[:id])

    @tab = "general"

    respond_to do |format|
      if @setting.update(setting_params.merge(active: true))
        format.html { redirect_to admin_general_path, notice: 'setting was successfully updated.' }
      else
        format.html { render 'admin/general', layout: 'layouts/admin' }
      end
    end
  end


  private

  def setting_params
    params.require(:setting).permit(:title, :number_of_writing)
  end
end
