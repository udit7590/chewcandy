class TagsController < ApplicationController
  layout 'blog_theme'

  before_action :tag, only: :show

  def show
    @blog_posts = (@user.try(:admin?) ? BlogPost.all : BlogPost.published).tagged_with(params[:name]).page(params[:page])
    @total_pages = @blog_posts.total_pages

    render 'blog_posts/index'
  end

  private
    def tag
      @tag = ActsAsTaggableOn::Tag.find_by(name: params[:name])
      unless @tag
        redirect_to blog_posts_path, alert: 'No such tag found'
      end
    end
end
