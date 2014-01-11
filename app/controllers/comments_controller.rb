class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]

  # POST /comments
  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.try(:id)))

    respond_to do |format|
      if @comment.save
        set_comment_count
        format.js { }

      else
        # TODO
        format.html { }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    respond_to do |format|

      if valid_user?(@comment.user) or valid_password?
        if @comment.update(comment_params.except(:password))
          set_comment_count
          format.js { }

        else
          # TODO
          format.html { }
        end

      else
        # TODO
        format.html { }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    respond_to do |format|

      if valid_user?(@comment.user) or valid_password?
        @comment_id = @comment.id
        writing = @comment.writing

        @comment.destroy
        @writings_comments_count = writing.comment.count
        format.js { }

      else
        # TODO
        format.html { }
      end
    end
  end



  private

  def valid_password?
    @comment.password == comment_params[:password]
  end

  def comment_params
    params.require(:comment).permit(:email, :name, :password, :writing_id, :content)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_comment_count
    writing = @comment.writing
    @writing_id = writing.id
    @writings_comments_count = writing.comment.count
  end
end