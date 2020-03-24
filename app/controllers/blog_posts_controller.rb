class BlogPostsController < ApplicationController
  layout 'blog_theme'
  before_action :check_admin, only: [:new, :create, :update, :edit]
  before_action :load_blog_post, only: [:edit, :update, :show, :destroy]

  def index
    @blog_posts = (@user.try(:admin?) ? BlogPost.all : BlogPost.published).order(created_at: :desc).page(params[:page])
    @total_pages = @blog_posts.total_pages
  end

  def new
    @blog_post = @user.blog_posts.new
  end

  def create
    @blog_post = @user.blog_posts.build(blog_post_params)
    if @blog_post.save
      redirect_to({ action: :index }, notice: 'Blog Post Created')
    else
      render action: 'new', status: :bad_request
    end
  end

  def show
    @comments = @blog_post.comment_threads.limit(100)
    @related_posts = BlogPost.published.where.not(id: @blog_post.id).
                    tagged_with(@blog_post.tag_list.split(','), any: true, order_by_matching_tag_count: true).
                    limit(3)
  end

  def edit
  end

  def update
    if @blog_post.update(blog_post_params)
      redirect_to({ action: :index }, notice: 'Blog Post updated')
    else
      render(action: 'edit', status: :bad_request)
    end
  end

  def destroy
    if @blog_post.destroy
      redirect_to({ action: :index }, notice: 'Blog Post Deleted')
    else      
      render({ action: :index }, alert: 'Unable to delete Blog Post')
    end
  end

  private

    def blog_post_params
      params.require(:blog_post).permit(:title, :slug, :video_url, :image, :tag_list, :html_overview, :html_content, :published)
    end

    def load_blog_post
      @blog_post = BlogPost.friendly.try(:find, params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to({ action: :index }, alert: 'Cannot find any such post')
    end
end
