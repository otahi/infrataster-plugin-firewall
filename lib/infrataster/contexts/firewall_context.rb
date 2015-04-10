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
