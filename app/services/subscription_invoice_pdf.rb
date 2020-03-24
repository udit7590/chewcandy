class SubscriptionInvoicePDF < Prawn::Document

  CONSTANTS = {
    table_head_color: 'dddddd',
    notice_color: '3399cc',
    notice_font_size: 12,
    heading_color: 'f4733d',
    table_row_color: 'ffffff',
    table_font_size: 16,
    head_font_size: 16
  }.freeze

  attr_reader :constants

  def initialize(subscription, constants = {})
    super(top_margin: 70)
    @subscription = subscription
    @user  = subscription.user
    @constants = CONSTANTS.merge(constants)

    build
  end

  def build
    header_row
    thank_you
    user_box
    # subscription_box
    footer_row
  end

  def header_row
    image "#{Rails.root}/app/assets/images/images/logo.png", position: :center
  end

  def footer_row
    text ' '
    text ' '
    text '-----------------------------------------------------------------------------------------------------------------------------'
    text 'Sales Team, ', align: :left
    text ' '
    text 'ChewCandy', align: :left
    text 'Delhi, India', align: :left
  end

  def thank_you
    move_down 20
    text 'Thank you for your subscription. This is your receipt', size: @constants[:notice_font_size], style: :bold, align: :center, color: @constants[:notice_color]
  end

  def user_box
    _self = self
    move_down 20
    text @user.name.humanize, size: @constants[:head_font_size], style: :bold, color: @constants[:heading_color]
    table user_details do
      row(0).font_style = :bold
      columns(1..3).align = :left
      self.column_widths = { 0 => 100, 1 => 150, 2 => 150, 3 => 100, 4 => 100 }
      self.row_colors = [_self.constants[:table_head_color], _self.constants[:table_row_color]]
    end
  end

  def user_details
    [['Email', 'Billing Address', 'Shipping Address', 'Phone Number']] + 
    [[@user.email, @user.billing_address.to_s, @user.shipping_address.to_s.presence || 'Same', @user.phone_number]]
  end

  def subscription_box
    _self = self
    move_down 20
    text 'Subscription Details', size: @constants[:head_font_size], style: :bold, color: @constants[:heading_color]
    text "ID: #{ @subscription.id }", size: @constants[:notice_font_size]
    text "Placed On: #{ @subscription.created_at.to_s(:long) }", size: @constants[:notice_font_size]
    text ' '
    table subscription_details do
      row(0).font_style = :bold
      row(-1).font_style = :bold
      row(-2).font_style = :bold
      row(-3).font_style = :bold
      columns(1..3).align = :left
      self.column_widths = { 0 => 100, 1 => 150, 2 => 150, 3 => 100 }
      self.row_colors = [_self.constants[:table_head_color], _self.constants[:table_row_color]]
    end
  end

  def subscription_details
    [['Candy Name', 'Quantity (In Grams)', 'Amount (Per 10 gm)', 'Total Amount']] + 
    subscription_rows +
    [['', '', 'VAT(@12.5%)', 'INR ' + @subscription.total_tax_amount.to_s]] +
    [['', '', 'Shipping Charges', 'INR ' + @subscription.total_shipping_amount.to_s]] +
    [['', '', 'Total', 'INR ' + @subscription.total_price_including_taxes_and_shipping.to_s]]
  end

  def subscription_rows
    @subscription.shopping_cart.shopping_cart_items.map do |shopping_cart_item|
      product = shopping_cart_item.product
      [product.name, shopping_cart_item.quantity, 'INR ' + product.price.to_s, 'INR ' + shopping_cart_item.amount.to_s]
    end
  end

end
