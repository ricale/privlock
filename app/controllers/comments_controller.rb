class CommentsController < ApplicationController

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
  end

  # DELETE /comments/1
  def destroy
  end



  private

  def comment_params
    params.require(:comment).permit(:email, :name, :password, :writing_id, :content)
  end
end