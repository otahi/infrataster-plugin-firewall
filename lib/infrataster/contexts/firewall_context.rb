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

        chain :via do |interface|
          @options ||={}
          @options.merge!(interface: interface)
          @chain_string ||= ''
          @chain_string += " via interface: #{interface}"
        end

        chain :icmp do
          @options ||= {}
          @options.merge!(protocol: :icmp) unless @options[:protocol]
        end

        chain :tcp do
          @options ||= {}
          @options.merge!(protocol: :tcp) unless @options[:protocol]
          @chain_string ||= ''
          @chain_string += ' tcp'
        end

        chain :udp do
          @options ||= {}
          @options.merge!(protocol: :udp) unless @options[:protocol]
          @chain_string ||= ''
          @chain_string += ' udp'
        end

        chain :dest_port do |port|
          port_number, protocol = port.to_s.split('/')
          @options ||= {}
          @options.merge!(dest_port: port_number)
          @options.merge!(protocol: protocol.to_sym) if protocol
          @options.merge!(protocol: :tcp) unless @options[:protocol]
          @chain_string ||= ''
          @chain_string += " dest_port: #{port}"
        end

        chain :source_port do |port|
          port_number, protocol = port.to_s.split('/')
          @options ||= {}
          @options.merge!(source_port: port_number)
          @options.merge!(protocol: protocol.to_sym) if protocol
          @options.merge!(protocol: :tcp) unless @options[:protocol]
          @chain_string ||= ''
          @chain_string += " source_port: #{port}"
        end

        chain :ack do |mode = :both|
          @options ||= {}
          @options.merge!(ack: mode)
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
