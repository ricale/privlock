class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
  before_action :set_writing_id

  # GET /writings/1/comments
  def index
    set_comment_count
    set_last_updated_timestamp

    respond_to do |format|

      if params[:last_updated_timestamp].nil? || params[:last_updated_timestamp].blank?
        @comments = Comment.where(writing_id: @writing_id)
        format.js { }

      else
        set_updated_comments
        format.js { render :update }
      end
    end
  end

  # POST /writings/1/comments
  def create
    @comment = Comment.new(comment_params.merge(user_id: current_user.try(:id), writing_id: @writing_id))

    respond_to do |format|

      if @comment.save
        set_comment_count
        set_last_updated_timestamp(@comment.updated_at)
        set_updated_comments(@comment.updated_at)
        send_new_comment_notification_mail(@comment) unless @comment.user == @comment.writing.user

        @new_comments <<= @comment
        format.js { render :update }

      else
        @alert = @comment.errors.full_messages.first
        format.js { render :error }
      end
    end
  end

  # PATCH/PUT /writings/1/comments/1
  def update
    respond_to do |format|

      if valid_user?(@comment.user) or valid_password?

        if @comment.update(comment_params.except(:password))
          set_comment_count
          set_last_updated_timestamp(@comment.updated_at)
          set_updated_comments(@comment.updated_at)
          send_updated_comment_notification_mail(@comment) unless @comment.user == @comment.writing.user

          @updated_comments <<= @comment
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

  # DELETE /writings/1/comments/1
  def destroy
    respond_to do |format|

      if valid_user?(@comment.user) or valid_password?
        @comment_id = @comment.id
        @comment.destroy

        set_comment_count
        set_last_updated_timestamp
        set_updated_comments
        send_destroyed_comment_notification_mail(@comment) unless @comment.user == @comment.writing.user

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

  def set_writing_id
    @writing_id = params[:writing_id]
  end

  def set_comment_count
    @writings_comments_count = Comment.where(writing_id: @writing_id).count
  end

  def set_last_updated_timestamp(updated_at = nil)
    @updated_timestamp = updated_at.nil? ? Time.now.to_i : updated_at.to_i
  end

  def set_updated_comments(updated_at = nil)
    last_updated_at = timestamp_to_time(params[:last_updated_timestamp])
    updated_at    ||= timestamp_to_time(@updated_timestamp.to_s)

    @new_comments     = Comment.created_between(last_updated_at, updated_at, @writing_id)
    @updated_comments = Comment.updated_between(last_updated_at, updated_at, @writing_id)
  end

  def timestamp_to_time(timestamp)
    Time.strptime(timestamp, "%s")
  end


  def send_new_comment_notification_mail(comment)
    writing = comment.writing
    user    = writing.user
    CommentMailer.new_comment(user, writing, comment).deliver
  end

  def send_updated_comment_notification_mail(comment)
    writing = comment.writing
    user    = writing.user
    CommentMailer.updated_comment(user, writing, comment).deliver
  end

  def send_destroyed_comment_notification_mail(comment)
    writing = comment.writing
    user    = writing.user
    CommentMailer.destroyed_comment(user, writing, comment).deliver
  end
end