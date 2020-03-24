class AddAttachmentImageToBlogPosts < ActiveRecord::Migration
  def self.up
    change_table :blog_posts do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :blog_posts, :image
  end
end
