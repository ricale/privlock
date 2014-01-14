class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]

  # POST /comments
  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.try(:id), writing_id: params[:writing_id]))

    respond_to do |format|

      if @comment.save
        set_comment_count
        set_last_updated_at(@comment.updated_at)
        updated_comments(@comment.writing_id, @comment.updated_at)
        format.js { }

      else
        @writing_id = @comment.writing_id
        @alert      = @comment.errors.full_messages.first
        format.js { render :error }
      end
    end
  end

  # PATCH/PUT /comments/1
  def update
    respond_to do |format|

      if valid_user?(@comment.user) or valid_password?

        if @comment.update(comment_params.except(:password))
          set_comment_count
          set_last_updated_at(@comment.updated_at)
          updated_comments(@comment.writing_id, @comment.updated_at)
          format.js { }

        else
          @alert = @comment.errors.full_messages.first
          format.js { render :error }
        end

      else
        @alert = "Need valid user or valid password"
        format.js { render :error }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    respond_to do |format|

      if valid_user?(@comment.user) or valid_password?
        @comment_id = @comment.id
        @comment.destroy

        set_comment_count
        updated_comments(@comment.writing_id, set_last_updated_at)
        format.js { }

      else
        @alert = "Need valid user or valid password"
        format.js { render :error }
      end
    end
  end

  def error

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
    @writing_id              = @comment.writing_id
    @writings_comments_count = @comment.writing.comment.count
  end

  def set_last_updated_at(updated_at = nil)
    @updated_at = updated_at || Time.now.utc
  end

  def updated_comments(writing_id, updated_at)
    @new_comments     = Comment.created_between(params[:last_updated_at], updated_at, writing_id)
    @updated_comments = Comment.updated_between(params[:last_updated_at], updated_at, writing_id)
  end
end