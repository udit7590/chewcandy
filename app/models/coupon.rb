class Coupon
  attr_reader :errors, :special

  def initialize(code, order_or_cart)
    @code = code.to_s.upcase
    @order_or_cart = order_or_cart
    @user = order_or_cart.try(:user)
    @errors = []
    special?
    check_validity
  end

  CURRENT_PUBLIC_COUPONS = {
    # 'CCFREESHIPPING' => ['Free Shipping', Constants::SHIPPING_AMOUNT, :fixed],
    'CCXMAS10' => ['Christmas Promotion Code', 10, :percent],
    'CCNEW10' => ['New Year Promotion Code', 10, :percent],
    'CHEWCANDY5' => ['Promotion Code', 5, :percent],
    'CHEWCANDY10' => ['Premium Promotion Code', 10, :percent]
  }

  SPECIAL_COUPONS = {
    'CCVALUE15' => ['Value Customer', 15, :percent]
  }

  def all_coupons
    cur = CURRENT_PUBLIC_COUPONS.dup
    cur.merge(SPECIAL_COUPONS)
  end

  def available_coupons
    coupons = CURRENT_PUBLIC_COUPONS.keys
    if user_has_completed_order?
      coupons += SPECIAL_COUPONS.keys
    end
    coupons
  end

  def user_has_completed_order?
    @user && @user.orders.where(state: 'completed').present?
  end

  def special?
    @special ||= SPECIAL_COUPONS.keys.include?(@code.to_s)
  end

  def applicable?
    return false if @code.blank?

    result = available_coupons.include?(@code)
    result && (special? ? user_has_completed_order? : result)
  end

  def check_validity
    if applicable?
      true
    else
      @errors = []
      @errors << "#{@code} is not a valid coupon"
      @errors << "You need to have at least one completed order in your account to redeem this coupon" if special? && !user_has_completed_order?
    end
  end

  # options[0] = Promotion String
  # options[1] = Amount/Percentage
  # options[2] = :fixed/:percent
  def discount_amount
    return 0.0 if @code.blank?

    if applicable?
      options = all_coupons[@code.to_s]
      if options[2] == :fixed
        options[1]
      elsif options[2] == :percent
        (@order_or_cart.total_product_amount * options[1]) / 100.0
      end
    else
      0.0
    end
  end

end
