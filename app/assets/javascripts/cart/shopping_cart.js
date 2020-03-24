var ShoppingCart = (function() {

  function ShoppingCart(container, button, productsContainer) {
    this.$container = container;
    this.$button = button;
    this.$productsContainer = productsContainer;

    // this.$container.off('click');
    // $('li.dropdown-menu.mega-dropdown a').on('click', function (event) {
    //     $(this).parent().toggleClass('open');
    // });
    $('.dropdown-menu a, .dropdown-menu button').click(function(e) {
        e.stopPropagation();
    });
  }

  ShoppingCart.prototype.bindEvents = function() {
    this.clickCartButtonEvent();
    this.clickAddToCartButtonEvent();
    this.clickRemoveFromCartButtonEvent();
    this.clickEmptyCartButtonEvent();
  };

  ShoppingCart.prototype.clickCartButtonEvent = function() {
    var _this = this;
    this.$button.click(function() {
      var $this = $(this);
      // debugger
      //If cart is empty
      if($this.find('.badge').html() == '0') {
        $('#shoppingCartDropDownEmpty').removeClass('hidden');
        $('#shoppingCartDropDown').addClass('hidden');
      } else {
        $('#shoppingCartDropDown').removeClass('hidden');
        $('#shoppingCartDropDownEmpty').addClass('hidden');
      }
    });
  };

  ShoppingCart.prototype.clickAddToCartButtonEvent = function() {
    var _this = this;
    this.$productsContainer.on('click', '.add-to-cart', function() {
      var $this = $(this),
          $listing = $this.parents('.product-listing'),
          productId = $listing.data('product-id'),
          path = Routes.addToCart(productId),
          minQuantity = parseInt($listing.data('min-quantity')),
          $quantityElement = $listing.find('.add-quantity'),
          quantity = parseInt($quantityElement.val() || 0);
          data = {
            quantity: quantity
          };

      if (quantity < minQuantity) {
        $quantityElement.focus();
        $quantityElement.siblings('.text-error').removeClass('hidden-with-space');
      } else {
        $quantityElement.siblings('.text-error').addClass('hidden-with-space');
        _this.sendRequestToAddProduct(path, data, $this);
      }
    });
  };

  ShoppingCart.prototype.clickRemoveFromCartButtonEvent = function() {
    var _this = this;
    this.$container.on('click', 'tr td:last', function() {
      var $this = $(this),
          $listing = $this.parents('tr'),
          productId = $listing.data('product-id'),
          path = Routes.removeFromCart(productId);
      _this.sendRequestToRemoveProduct(path, null);
    });
  };

  ShoppingCart.prototype.clickEmptyCartButtonEvent = function() {
    var _this = this;
    this.$container.find('.empty-cart').click(function() {
      var $this = $(this),
          path = Routes.emptyCart;
      _this.sendRequestToEmptyCart(path, null);
    });
  };

  ShoppingCart.prototype.sendRequestToAddProduct = function(path, data, $addToCartButton) {
    var _this = this;
    $.getJSON(path, data)
     .done(function(jsonData) {

        // Remove hidden class from cart drop down if present
        _this.$container.removeClass('hidden');

        // Add item to cart based on if it is already present in cart
        var existingRowForItem = _this.$container.find('table tr[data-product-id=' + jsonData['item']['product_id'] + ']');
        if(existingRowForItem.length > 0) {
          var columns = existingRowForItem.children();
          $(columns[0]).html(jsonData['item']['product_name']);
          $(columns[1]).html(jsonData['item']['quantity_display'] + '');
          $(columns[2]).html('INR ' + jsonData['item']['amount']);
        } else {
          var $productHtml = $('<tr>')
                      .append('<td>' + jsonData['item']['product_name'] + '</td>')
                      .append('<td>' + jsonData['item']['quantity_display'] + '</td>')
                      .append('<td>INR ' + jsonData['item']['amount'] + '</td>')
                      .append('<td class="pull-right"><a href="#"><img src="/assets/remove.png" width="25" height="25" /></a></td>')
                      .attr('data-product-id', jsonData['item']['product_id']);
          _this.$container.find('table').append($productHtml);
        }

        // Transfer effect for added item
        var $productContainer = $addToCartButton.siblings('div'),
            productImagePath = $productContainer.find('img.product-image-thumb').attr('src');
        $addToCartButton.siblings('div').effect("transfer", { to: _this.$button }, 1000 );
        $('.ui-effects-transfer').css('background-image', 'url(' + productImagePath + ')');

        //Update total quantity for cart
        _this.$button.find('span').html(jsonData['cart']['total_quantity']);
    })
    .error(function(jsonData) {
      alert(jsonData.responseJSON.error);
    });
  };

  ShoppingCart.prototype.sendRequestToRemoveProduct = function(path, data) {
    var _this = this;
    $.getJSON(path, data)
     .done(function(jsonData) {

        // Add hidden class to cart drop down if cart empty
        if(jsonData['cart']['total_quantity'] < 1) {
          _this.$container.addClass('hidden');
        }

        // Remove item to cart based on if it is already present in cart
        var $existingRowForItem = _this.$container.find('table tr[data-product-id=' + jsonData['item']['product_id'] + ']');
        if($existingRowForItem.length > 0) {
          $existingRowForItem.remove();
        }

        //Update total quantity for cart
        _this.$button.find('span').html(jsonData['cart']['total_quantity']);
    });
  };

  ShoppingCart.prototype.sendRequestToEmptyCart = function(path, data) {
    var _this = this;
    $.getJSON(path, data)
     .done(function(jsonData) {
        if(jsonData['success']) {

          // Add hidden class to cart drop down
          _this.$container.addClass('hidden');

          //Remove rows
          _this.$container.find('table tr').remove();

          //Update total quantity for cart
          _this.$button.find('span').html('0');
        }
    });
  };
  //Return the class
  return ShoppingCart;

})();

$(function() {
  var shoppingCart = new ShoppingCart($('#shoppingCartDropDown'), $('#shoppingCartButton'), $('#candyProducts'));
  shoppingCart.bindEvents();

});

