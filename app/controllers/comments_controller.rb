class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]

  # POST /comments
  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.try(:id)))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to show_path(@comment.writing), notice: 'comment was successfully created.' }
      else
        format.html { redirect_to index_path, notice: @comment.errors.full_messages.first }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    respond_to do |format|

      if valid_user? or valid_password?
        if @comment.update(comment_params.except(:password))
          format.html { redirect_to show_path(@comment.writing), notice: 'comment was successfully updated.' }
        else
          format.html { redirect_to show_path(@comment.writing), notice: @comment.errors.full_messages.first }
        end

      else
        format.html { redirect_to show_path(@comment.writing), notice: 'need vaild user or vaild password.' }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    respond_to do |format|

      if valid_user? or valid_password?
        @comment.destroy
        format.html { redirect_to index_path, notice: 'comment was successfully destroyed.' }

      else
        format.html { redirect_to show_path(@comment.writing), notice: 'need vaild user or vaild password.' }
      end
    end
  end



  private

  def valid_user?
    !current_user.nil? && @comment.user == current_user
  end

  def valid_password?
    @comment.password == comment_params[:password]
  end

  def comment_params
    params.require(:comment).permit(:email, :name, :password, :writing_id, :content)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end