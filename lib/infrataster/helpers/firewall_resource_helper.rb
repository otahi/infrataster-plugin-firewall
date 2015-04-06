require 'rspec'
require 'infrataster/resources'

module Infrataster
  module Helpers
    # Firewall resouce helper
    module ResourceHelper
      def firewall(*args)
        Resources::FirewallResource.new(*args)
      end
    end
  end
end
