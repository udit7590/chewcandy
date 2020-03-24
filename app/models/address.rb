class Address < ActiveRecord::Base
  SHIPMENT_STATES = {
    'delhi' => 'Delhi NCR',
    'haryana' => 'Haryana',
    'uttar_pradesh' => 'Uttar Pradesh',
    'kolkata' => 'Kolkata',
    'maharashtra' => 'Maharashtra',
    'bangalore' => 'Bangalore',
    'chennai' => 'Chennai',
    'kochi' => 'Kochi',
    'goa' => 'Goa',
    'hyderabad' => 'Hyderabad'
  }.freeze

  belongs_to :user

  # -------------- SECTION FOR VALIDATIONS --------------------
  # -------------------------------------------------------------
  before_validation :downcase_and_strip_attributes

  validates :full_address, :state, :city, :country, :pincode, presence: true
  validates :full_address, length: { maximum: 250 }
  validates :state, length: { maximum: 60 }
  validates :city, length: { maximum: 60 }
  validates :country, length: { maximum: 60 }
  validates :pincode, length: { maximum: 6 }
  validates :country, inclusion: { in: %w(india), message: "%{value} is currently not under our coverage area. We currently deal in India only" }
  validates :state, inclusion: { in: SHIPMENT_STATES.keys, message: "%{value} is currently not under our coverage area. We currently deal in #{SHIPMENT_STATES.values.join(', ')} (India) only" }
  validates :full_address, allow_blank: true, length: { minimum: 3, maximum: 1000 }

  def to_s
    (full_address + "\n" + city + ', ' + state + ' - ' + pincode.to_s + "\n" + country)
  end

  protected

    def downcase_and_strip_attributes
      self.state = state.downcase.strip
      self.city = city.downcase.strip
      self.country = country.downcase.strip
      self.full_address = full_address.strip
    end

end
