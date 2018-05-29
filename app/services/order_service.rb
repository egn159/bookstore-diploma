class OrderService
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def activate_coupon_with_message(coupon)
    coupon = Coupon.find_by(code: coupon)
    msg = check_coupon_errors(coupon)
    return msg unless msg.nil?
    @order.update(coupon: coupon)
    I18n.t('coupon.activatesuccess')
  end

  def check_coupon_errors(coupon)
    return I18n.t('coupon.noexist') if coupon.nil?
    return I18n.t('coupon.cantactivate') if @order.order_items.blank?
    return I18n.t('coupon.sumerror') if @order.subtotal < coupon.min_sum_to_activate
    return I18n.t('coupon.termerror') if !coupon.expires.nil? && Time.now > coupon.expires
    return I18n.t('coupon.alreadyactivated') if coupon.activated && coupon.coupon_type == 'one_time'
  end
end
