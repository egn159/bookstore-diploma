require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class InfoOrder < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-list-alt'
        end

        register_instance_option :only do
          Order
        end

        register_instance_option :member do
          true
        end
      end
    end
  end
end
