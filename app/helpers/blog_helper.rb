module BlogHelper
  def recent_posts
    @recent_posts ||= BlogPost.published.order(created_at: :desc).limit(5)
  end
end
