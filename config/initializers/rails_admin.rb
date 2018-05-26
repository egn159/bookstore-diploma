require Rails.root.join('lib', 'rails_admin', 'moderation_review.rb')
require Rails.root.join('lib', 'rails_admin', 'order_methods.rb')

RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  config.authorize_with :cancan

  config.model 'Book' do
    exclude_fields :orders, :order_items
  end

  config.model 'Author' do
    exclude_fields :book
  end

  config.model 'Order' do
    list do
      scopes %i[completed all]
    end
  end

  config.model 'Review' do
    list do
      scopes %i[unprocessed all approved rejected]
    end
  end

  hidden_models = %w[InfoBook Image OrderItem CreditCard BillingAddress ShippingAddress]

  hidden_models.each do |model_name|
    config.model model_name.to_s do
      visible false
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new

    show_review
    check_review

    info_order

    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
