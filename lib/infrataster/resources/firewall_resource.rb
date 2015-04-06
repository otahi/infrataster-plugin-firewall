require 'infrataster'

module Infrataster
  module Resources
    # Infrataster Firewall resource
    class FirewallResource < BaseResource
      Error = Class.new(StandardError)

      attr_reader :dest_node

      def initialize(dest_node, options={})
        @dest_node = dest_node
      end

      def to_s
        'via firewall'
      end
    end
  end
end
