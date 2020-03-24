class ShoppingCartsController < ApplicationController
 
  def show
    cart_ids = @cart.items.pluck(:product_id)
    @cart_products = Product.find(cart_ids)
  end
 
  def add
    @added_item = @cart.add(params[:product_id].to_i, params[:quantity].to_i)
    if(@added_item.errors.empty?)
      render 'add', status: 200
    else
      error_messages = @added_item.errors.full_messages.join(',')
      render json: { error: "Unable to add the item to your candy bag. #{ error_messages }" }, status: 400
    end
  end
 
  def remove
    if(@removed_item = @cart.remove(params[:product_id].to_i))
      render 'remove', status: 200
    else
      render json: { error: 'Unable to remove the item from your candy bag.' }, status: 400
    end
  end

  def empty
    @cart.empty
    if @cart.empty?
      render json: { success: true }, status: 200
    else
      render json: { error: 'Unable to empty your candy bag.' }, status: 400
    end
  end

end
