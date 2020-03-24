class Product < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  VEGETARIAN              = 'vegetarian'
  NON_VEGETARIAN          = 'non_vegetarian'
  GRAM                    = 'gram'
  PIECE                   = 'piece'
  TAX_INCLUSIVE           = true
  TAX_EXCLUSIVE           = false

  MIN_QUANTITY_UNIT_TYPES = [GRAM, PIECE]
  FOOD_TYPES              = [VEGETARIAN, NON_VEGETARIAN]

  PRICE_COMPOSITION       = [['tax_exclusive', TAX_EXCLUSIVE], ['tax_inclusive', TAX_INCLUSIVE]]

  has_attached_file :image, styles: { 
    thumbnail: '370x232#',
    preview: '570x356#'
  }

  # ------------------------------------------------------------------------------------------
  # SECTION FOR VALIDATIONS
  # ------------------------------------------------------------------------------------------

  validates :name, :price, :food_type, :min_quantity, :min_quantity_unit, presence: true
  validates :price, :min_quantity, numericality: true
  validates :food_type, inclusion: { in: FOOD_TYPES }
  validates :min_quantity_unit, inclusion: { in: MIN_QUANTITY_UNIT_TYPES }

  validates_attachment_content_type :image, content_type: %w(image/jpg image/jpeg image/png)
  validates_attachment_size :image, less_than: 2.megabyte, 
                            unless: Proc.new { |image| image.image_file_name.blank? }

  # ------------------------------------------------------------------------------------------
  # SECTION FOR SCOPES
  # ------------------------------------------------------------------------------------------
  scope :vegetarian, -> { where(food_type: VEGETARIAN) }
  scope :non_vegetarian, -> { where(food_type: NON_VEGETARIAN) }
  scope :piece_wise, -> { where(min_quantity_unit: PIECE) }
  scope :gram_wise, -> { where(min_quantity_unit: GRAM) }

  def calculate_amount(quantity)
    case min_quantity_unit
    when GRAM
      price * (quantity / min_quantity)
    when PIECE
      price * (quantity / min_quantity)
    end
  end

  def calculate_amount_with_tax(quantity)
    without_tax = calculate_amount(quantity)
    (without_tax + (without_tax * Constants::VAT_RATE))
  end

  def max_quantity
    unit == GRAM ? Constants::MAX_QUANTITY_GRAMS : Constants::MAX_QUANTITY_PIECES
  end

  def unit
    min_quantity_unit
  end

  # def should_generate_new_friendly_id?
  #   new_record? || slug.blank?
  # end
end
