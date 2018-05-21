require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class ShowReview < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :only do
          Review
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-info-sign'
        end
      end
      class CheckReview < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :only do
          Review
        end

        register_instance_option :visible? do
          false
        end

        register_instance_option :member do
          true
        end

        register_instance_option :controller do
          Proc.new do
            status = 'rejected'
            if params['status'] == 'approve'
              status = 'approved'
              coupon = Coupon.generate_review_coupon
              ReviewMailer.with(review: @object, coupon: coupon).approve_email.deliver_now
            end

            @object.update_attribute(:status, status)
            flash[:notice] = "You have #{status.capitalize} the review \"#{@object.title}\""
            redirect_to index_path(model_name: 'review')
          end
        end
      end

      class Show < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          [Review].exclude? bindings[:object].class
        end
      end
    end
  end
end
