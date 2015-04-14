require 'infrataster'
require 'infrataster-plugin-firewall'

module Infrataster
  module Contexts
    # Infrataster Firewall context
    class FirewallContext < BaseContext
      extend RSpec::Matchers::DSL

      matcher(:be_reachable) do
        match do
          @options ||= {}
          transfer =
            Plugin::Firewall::Transfer.new(resource.src_node,
                                           resource.dest_node,
                                           @options)
          transfer.reachable?
        end

        chain :icmp do
          @options ||= {}
          @options.merge!(protocol: :ICMP) unless @options[:protocol]
        end

        chain :tcp do
          @options ||= {}
          @options.merge!(protocol: :TCP) unless @options[:protocol]
          @chain_string ||= ''
          @chain_string += ' tcp'
        end

        chain :udp do
          @options ||= {}
          @options.merge!(protocol: :UDP) unless @options[:protocol]
          @chain_string ||= ''
          @chain_string += ' udp'
        end

        chain :dest_port do |port|
          @options ||= {}
          @options.merge!(dest_port: port)
          @options.merge!(protocol: :TCP) unless @options[:protocol]
          @chain_string ||= ''
          @chain_string += " dest_port: #{port}"
        end

        failure_message do
          s = "expected to reach to #{resource.dest_node}"
          s + "#{@chain_string}, but did not."
        end

        failure_message_when_negated do
          s = "expected not to reach to #{resource.dest_node}"
          s + "#{@chain_string}, but did."
        end

        description do
          "reach to #{resource.dest_node}#{@chain_string}"
        end
      end
    end
  end
end
