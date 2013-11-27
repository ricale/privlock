class WritingsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  before_action :set_writing, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit]

  # GET /
  # GET /categories/1/writings
  def index
    if params[:category_id]
      @writings = Category.find(params[:category_id]).descendants_writings.page(params[:page])  
    else
      @writings = Writing.all.page(params[:page])
    end
  end

  # GET /1
  def show
  end

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
        format.html { redirect_to @writing, notice: 'Writing was successfully created.' }
      else
        format.html {
          set_categories
          render action: 'new', alert: 'fail'
        }
      end
    end
  end

  # PATCH/PUT /writings/1
  def update
    respond_to do |format|
      if @writing.update(writing_params)
        format.html { redirect_to @writing, notice: 'Writing was successfully updated.' }
      else
        format.html {
          set_categories
          render action: 'edit', alert: 'fail'
        }
      end
    end
  end

  # DELETE /writings/1
  def destroy
    @writing.destroy
    respond_to do |format|
      format.html { redirect_to writings_url }
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
