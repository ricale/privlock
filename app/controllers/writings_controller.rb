class WritingsController < ApplicationController
  before_action :authenticate_user!
  
  before_action :set_writing, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit]



  # GET /new
  def new
    @writing = Writing.new
  end

  # GET /1/edit
  def edit
  end




  # POST /writings
  def create
    @writing = Writing.new(writing_params)

    respond_to do |format|
      if @writing.save
        format.html { redirect_to show_path(@writing), notice: 'Writing was successfully created.' }
      else
        format.html {
          set_categories
          render action: 'new'
        }
      end
    end
  end

  # PATCH/PUT /writings/1
  def update
    respond_to do |format|
      if @writing.update(writing_params)
        format.html { redirect_to show_path(@writing), notice: 'Writing was successfully updated.' }
      else
        format.html {
          set_categories
          render action: 'edit'
        }
      end
    end
  end

  # DELETE /writings/1
  def destroy
    @writing.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end




  private

  def set_writing
    @writing = Writing.find(params[:id])
  end

  def set_categories
    @categories = Category.hierarchy_categories(:all)
  end

  def writing_params
    params.require(:writing).permit(:title, :content, :category_id)
  end
end
