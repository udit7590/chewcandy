$(window).load(function() {

  // Instance the tour
  var tour = new Tour({
    steps: [
    {
      element: "#bootstrapTourStep1",
      title: "Hi, Welcome to ChewCandy!",
      placement: "bottom",
      content: "We are India's first one stop solution for all your candy needs. To start with, let us help you get familiar with our website. Follow the on screen instructions to proceed. You can end the tour at any time."
    },
    {
      element: "#bootstrapTourStep2",
      title: "Navigation",
      content: "This is our site's navigation. You can click this button to see what candies we have in our store."
    },
    {
      element: ".tour-candies:first",
      title: "Our Candies!!!",
      content: "This is where all our candies are listed. To know more about any candy, simply take your mouse cursor over one and click the plus icon that appears over the candy."
    },
    {
      element: ".tour-candies-add-quantity:first",
      title: "Choose quantity of your candies.",
      placement: "bottom",
      content: "When you have decided which candy you want, you can fill in how much grams of that candy you require and click on 'Add To Cart' button below it."
    },
    {
      element: "#shoppingCartButton",
      title: "Checkout and Payment",
      placement: "bottom",
      content: "I hope you have chosen enough candies to feed your craving. Now go to the payment page by clicking this bag in the navigation bar and clicking checkout. You can also remove some candies if you change your mind. Note: This button will only be clickable when you have added candies in your bag.  "
    }
  ]});

  // Initialize the tour
  tour.init();

  // Start the tour
  tour.start();
});
