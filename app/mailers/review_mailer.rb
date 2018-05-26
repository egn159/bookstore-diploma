class ReviewMailer < ApplicationMailer
  def approve_email
    @review = params[:review]
    @coupon = params[:coupon]
    mail(to: @review.user.email, subject: '[BookStore] Your review was approved')
  end
end
