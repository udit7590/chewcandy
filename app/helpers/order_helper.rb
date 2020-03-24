module OrderHelper
  def order_identifier(order)
    order.number || order.id
  end
end
