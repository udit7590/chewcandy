# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.

# Add JS
Rails.application.config.assets.precompile += %w( 
  theme.js
  user/login_register.js
  cart/shopping_cart.js
  order/order_form.js
  bootstrap_tours/home.js
  blog_theme.js
)

# Add Stylesheets
Rails.application.config.assets.precompile += %w( 
  theme.css
  custom.css
  admin.css
  blog_theme.css
)