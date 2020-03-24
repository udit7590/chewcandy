class BlogPost < ActiveRecord::Base
  extend FriendlyId

  belongs_to :user

  acts_as_taggable

  acts_as_commentable
  has_many :comments, as: :commentable

  paginates_per 15

  friendly_id :title, use: [:slugged, :history]

  validates :title, :html_content, presence: true

  has_attached_file :image, styles: { 
    thumbnail: '370x232#',
    preview: '220x140#',
    large: '690x',
    blog_index: '525x264#',
    blog_index_thumb: '170×170',
  }

  validates_attachment_content_type :image, content_type: %w(image/jpg image/jpeg image/png)
  validates_attachment_size :image, less_than: 10.megabyte, 
                            unless: Proc.new { |image| image.image_file_name.blank? }

  scope :published, -> { where(published: true) }

  before_save :set_meta_description, :set_meta_image

  def status
    published? ? 'published' : 'draft'
  end


  private

  # Filter html content to get plain text and set first 200 characters as meta_description.
  #
  # @return [void]
  def set_meta_description
    html = html_overview || html_content

    self.meta_description =
      html.
        gsub(/<\/?[^>]*>/, ' ').  # replace HTML tags with spaces
        gsub(/&\w{1,9};|"/, '').  # remove HTML special chars and double quotes
        gsub(/\n+/, " ").         # remove new lines
        gsub(/\s+/, ' ').         # remove duplicated spaces
        strip[0..200]             # strip spaces and get first 200 chars
  end

  # Find first img tag and in content and grab its source.
  #
  # @return [void]
  def set_meta_image
    regexp = /<img[^>]+src=["']([^"']*)/
    if img_tag = html_content.match(regexp)
      self.meta_image = img_tag[1]
    end
  end
end
