require 'razorpay'

# Razorpay use rubocop for checking style guidelines
# Webmock is used as the request mock framework
# HTTParty is used for making requests
# Travis is used for CI
# Coveralls is used for coverage reports
Razorpay.setup("merchant_key_id", "merchant_key_secret")