class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]

  def index
    set_comment_count
    updated_at = timestamp_to_time(set_last_updated_timestamp.to_s)
    updated_comments(params[:writing_id], updated_at)
  end

  # POST /comments
  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.try(:id), writing_id: params[:writing_id]))

    respond_to do |format|

      if @comment.save
        set_comment_count
        set_last_updated_timestamp(@comment.updated_at)
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
          set_last_updated_timestamp(@comment.updated_at)
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
        updated_at = timestamp_to_time(set_last_updated_timestamp.to_s)
        updated_comments(@comment.writing_id, updated_at)
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
    params.require(:comment).permit(:email, :name, :password, :content)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_comment_count
    @writing_id              = params[:writing_id]
    @writings_comments_count = Comment.where(writing_id: params[:writing_id]).count
  end

  def set_last_updated_timestamp(updated_at = nil)
    @updated_timestamp = updated_at.nil? ? Time.now.to_i : updated_at.to_i
  end

  def updated_comments(writing_id, updated_at)
    if params[:last_updated_timestamp].nil? || params[:last_updated_timestamp].blank?
      @new_comments     = Comment.created_before(updated_at, writing_id)
      @updated_comments = []

    else
      last_updated_at = timestamp_to_time(params[:last_updated_timestamp])
      @new_comments     = Comment.created_between(last_updated_at, updated_at, writing_id)
      @updated_comments = Comment.updated_between(last_updated_at, updated_at, writing_id)
      puts last_updated_at.class
      puts updated_at.class
    end
  end

  def timestamp_to_time(timestamp)
    Time.strptime(timestamp, "%s")
  end
end