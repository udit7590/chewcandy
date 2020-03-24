var OrderForm = (function() {

  function OrderForm(sameAddressCheckbox) {
    this.$sameAddressCheckbox = sameAddressCheckbox;
  }

  OrderForm.prototype.bindEvents = function() {
    this.selectSameAddressCheckboxChangeEvent();
  };

  OrderForm.prototype.selectSameAddressCheckboxChangeEvent = function() {
    this.$sameAddressCheckbox.change(function() {
      var $shippingAddressContainer = $('#shippingAddressContainer');

      if(this.checked) {
        $shippingAddressContainer.fadeOut();
        $shippingAddressContainer.find('input,textarea,select').attr('disabled', 'true');
      } else {
        $shippingAddressContainer.fadeIn();
        $shippingAddressContainer.find('input,textarea,select').removeAttr('disabled');
      }
    });
  };

  //Return the class
  return OrderForm;

})();

$(function() {
  var orderForm = new OrderForm($('#user_same_as_billing_address'));
  orderForm.bindEvents();
});

