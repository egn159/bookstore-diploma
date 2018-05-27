class CheckoutController < ApplicationController
  before_action :authenticate_user!, except: [:start]
  before_action :save_cart_after_login, :init, :check_order_not_empty

  def start
    start_save_cart unless user_signed_in?
    cookies.delete(:return_to_confirm)
    redirect_to :checkout
  end

  def index
    @form = CheckoutForm.new(@order)
    return if cookies[:last_completed_order_id].nil?
    cookies.delete(:last_completed_order_id)
    OrderMailer.with(user: @user, order: @order).complete_email.deliver_now
    return if @order.coupon.nil?
    coupon = @order.coupon
    coupon.update(activated: true) if coupon.coupon_type == 'one_time'
  end

  def edit_data
    @order.checkout_state = state_params[:type]
    return unless @order.save
    cookies[:return_to_confirm] = true
    redirect_to :checkout
  end

  def next_stage
    status = @service.next_stage(@state_layout)
    @service.return_to_confirm(status)
    if status == :success
      save_order_for_last_step if @state_layout == 'confirm'
      return redirect_to :checkout
    end
    @form = CheckoutForm.new(@order)
    render 'index'
  end

  private

  def init
    @user = current_user
    @order = select_order.decorate
    @state_layout = @order.checkout_state
    @service = CheckoutService.new(params, cookies, @user, @order)
  end

  def check_order_not_empty
    return if @order.order_items.present?
    @order.reset_state! unless @order.address?
    flash[:alert] = t('checkout.emptycart')
    redirect_to cart_page_url
  end

  def select_order
    last_completed_order_id = cookies[:last_completed_order_id]
    return last_order if last_completed_order_id.nil?
    @user.orders.find_by(id: last_completed_order_id)
  end

  def save_order_for_last_step
    cookies[:last_completed_order_id] = @order.id
  end

  def start_save_cart
    cookies[:save_cart] = true if last_order.order_items.present?
  end

  def save_cart_after_login
    return if !cookies[:save_cart] || !guest_order
    order = guest_order
    last_order.destroy
    order.update_attributes(user: current_user)
    clear_guest_cookies
  end

  def state_params
    params.permit(:type)
  end
end
