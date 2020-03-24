var Routes = {

  addToCart: function(product_id) {
    return '/shopping_cart/add/' + product_id;
  },

  removeFromCart: function(product_id) {
    return '/shopping_cart/remove/' + product_id;
  },

  emptyCart: '/shopping_cart/empty'
}
