class CommentMailer < ActionMailer::Base
  default from: "no-reply@ricalest.net"

  def new_comment(user, writing, comment)
    @user    = user
    @writing = writing
    @comment = comment
    mail(to: @user.email, subject: "New comment is registered")
  end

  def updated_comment(user, writing, comment)
    @user    = user
    @writing = writing
    @comment = comment
    mail(to: @user.email, subject: "Comment is updated")
  end

  def destroyed_comment(user, writing, comment)
    @user    = user
    @writing = writing
    @comment = comment
    mail(to: @user.email, subject: "Comment is destroyed")
  end
end
