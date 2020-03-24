class OrderInvoicePDF < Prawn::Document

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

  def initialize(order, constants = {})
    super(top_margin: 70)
    @order = order.decorate
    @user  = order.user
    @constants = CONSTANTS.merge(constants)

    build
  end

  def build
    header_row
    thank_you
    user_box
    order_box
    footer_row
  end

  def header_row
    # text 'Go Creative', size: 30, style: :bold, align: :center
    image "#{Rails.root}/app/assets/images/images/logo_invoice_header.png", position: :center
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
    text 'Thank you for placing the order. This is your receipt', size: @constants[:notice_font_size], style: :bold, align: :center, color: @constants[:notice_color]
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

  def order_box
    _self = self
    move_down 20
    text 'Order Details', size: @constants[:head_font_size], style: :bold, color: @constants[:heading_color]
    text "ID: #{ @order.number }", size: @constants[:notice_font_size]
    text "Placed On: #{ @order.created_at.to_s(:long) }", size: @constants[:notice_font_size]
    text ' '
    table order_details do
      row(0).font_style = :bold
      row(-1).font_style = :bold
      row(-2).font_style = :bold
      row(-3).font_style = :bold
      columns(1..3).align = :left
      self.column_widths = { 0 => 100, 1 => 150, 2 => 150, 3 => 100 }
      self.row_colors = [_self.constants[:table_head_color], _self.constants[:table_row_color]]
    end
  end

  def order_details
    [['Candy Name', 'Quantity (In Grams/Pieces)', 'Amount', 'Total Amount']] + 
    order_rows + summary_order_rows
  end

  def order_rows
    (@order.shopping_cart && @order.shopping_cart.shopping_cart_items.includes(:product).decorate.map do |shopping_cart_item|
      product = shopping_cart_item.product.decorate
      [product.name, shopping_cart_item.quantity, product.rate_string, shopping_cart_item.amount]
    end).to_a
  end

  def summary_order_rows
    rows = []
    rows += [['', '', 'VAT(@12.5%)', Currency.string + @order.total_tax_amount.to_s]]
    rows += [['', '', 'Shipping Charges', Currency.string + @order.total_shipping_amount.to_s]]
    rows += [['', '', 'Discount', Currency.string + @order.discount_amount.to_s]] if @order.coupon_code.present?
    rows += [['', '', 'Total', Currency.string + @order.net_amount.to_s]]
    rows
  end

end
