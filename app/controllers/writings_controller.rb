class WritingsController < ApplicationController
  # GET /writings
  def index
    @writings = Writing.order('created_at desc')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /writings/1
  def show
    @writing = Writing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /writings/new
  def new
    @writing = Writing.new

    @categories = []
    Category.order('family, orderby').each do |category|
      @categories << [category[:name], category[:id]]
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /writings/1/edit
  def edit
    @writing = Writing.find(params[:id])

    @categories = []
    Category.order('family, orderby').each do |category|
      @categories << [category[:name], category[:id]]
    end
  end

  # POST /writings
  def create
    @writing = Writing.new(params[:writing])

    respond_to do |format|
      if @writing.save
        format.html { redirect_to @writing, notice: 'Writing was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /writings/1
  def update
    @writing = Writing.find(params[:id])

    respond_to do |format|
      if @writing.update_attributes(params[:writing])
        format.html { redirect_to @writing, notice: 'Writing was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /writings/1
  def destroy
    @writing = Writing.find(params[:id])
    @writing.destroy

    respond_to do |format|
      format.html { redirect_to writings_url }
    end
  end
end