module ProductsHelper
  FOOD_TYPE_IMAGE_PATHS = {
    vegetarian:     'type_veg.png',
    non_vegetarian: 'type_nonveg.png'
  }.freeze

  def hide_product_details?(product)
    params[:candy_name].to_s != product.id.to_s
  end
end
