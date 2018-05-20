class OrderMailer < ApplicationMailer
  def complete_email
    @order = params[:order]
    @user = params[:user]
    mail(to: @user.email, subject: '[BookStore] Order Information')
  end

  def first_gift_email
    @order = params[:order]
    @coupon = params[:coupon]
    mail(to: @order.user.email, subject: '[BookStore] Gift for You!')
  end
end
