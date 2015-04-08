require 'infrataster'

module Infrataster
  module Resources
    # Infrataster Firewall resource
    class FirewallResource < BaseResource
      Error = Class.new(StandardError)

      attr_reader :src_node
      attr_reader :dest_node

      def initialize(src_node, dest_node, options = {})
        @src_node = src_node
        @dest_node = dest_node
      end

      def to_s
        'via firewall'
      end
    end
  end
end
