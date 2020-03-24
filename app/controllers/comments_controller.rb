class CommentsController < ApplicationController
  layout 'blog_theme'
  before_action :load_blog_post
  before_action :load_parent_comment, only: :reply
  before_action :check_not_registered_user_as_guest, only: :create

  def index
    render 'blog_posts/show'
  end

  def new
  end

  def create
    @comment = Comment.build_from( @blog_post, @user.id, comment_params )
    if @comment.save
      redirect_to @blog_post
    else
      flash.now[:alert] = 'Not able to capture your comment. Please provide all required parameters'
      render 'blog_posts/show'
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  def reply
    @comment = Comment.build_from( @blog_post, @user.id, comment_params )
    if @comment.save
      @comment.move_to_child_of(@parent_comment)
      redirect_to @blog_post
    else
      render @blog_post, alert: 'Not able to capture your comment. Please provide all required parameters'
    end
  end

  # def abuse
  # end

  # def unabuse
  # end

  private

    def comment_params
      # Unpermitted : commentable_id, commentably_type, user_id, lft, rgt, :parent_id
      if @user.guest?
        params.require(:comment).permit(:id, :title, :body, :subject, :email, :full_name)
      else
        params.require(:comment).permit(:id, :title, :body, :subject)
      end
    end

    def check_not_registered_user_as_guest
      if @user.guest?
        if User.find_by(email: params[:comment][:email]).present?
          redirect_to @blog_post, alert: 'You need to log in before posting comment with this email.'
        end
      end
    end

    def load_blog_post
      @blog_post = BlogPost.friendly.find(params[:blog_post_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to blog_posts_path, alert: 'No such blog post found'
    end

    def load_parent_comment
      @parent_comment = Comment.find_by(id: params[:comment_id])
      unless @parent_comment
        redirect_to @blog_post, alert: 'No such comment found'
      end
    end
end
