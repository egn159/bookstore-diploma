RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  config.authorize_with :cancan# do
    #redirect_to main_app.root_path unless current_user.is_admin?
  #end
  ## == Cancan ==


  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
  config.model 'Book' do
    config.model 'InfoBook' do
      exclude_fields :book
    end
    exclude_fields :orders, :order_items
  end

  config.model 'Author' do
    exclude_fields :book
  end
=begin
  config.model 'InfoBook' do
    visible false
  end

  config.model 'Image' do
    visible false
  end

  config.model 'OrderItem' do
    visible false
  end

  config.model 'CreditCard' do
    visible false
  end

  config.model 'CreditCard' do
    visible false
  end

  config.model 'ShippingAddress' do
    visible false
  end
=end
  config.included_models = ["Book", "Author", "Category", "Order", "User"]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
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
