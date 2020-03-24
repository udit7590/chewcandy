class CreateBlogPost < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.integer  :user_id
      t.string   :slug
      t.string   :title
      t.boolean  :published
      t.datetime :published_at

      t.string   :markup_lang 
      t.text     :raw_content 

      t.text     :html_content
      t.text     :html_overview

      t.string   :video_url
      t.string   :meta_description
      t.string   :meta_image

      t.timestamps
    end

    add_index :blog_posts, :user_id
    add_index :blog_posts, :slug, unique: true
    add_index :blog_posts, :published_at

  end
end
