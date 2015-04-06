require 'infrataster'

module Infrataster
  module Contexts
    # Infrataster Firewall context
    class FirewallContext < BaseContext
      extend RSpec::Matchers::DSL

      matcher(:be_reachable)do |expected|
        match do |actual|
          true
        end

        failure_message_when_negated do
          'negative fail'
        end

        failure_message do
          'fail'
        end

        description do
          "reach to #{resource.dest_node}"
        end
      end
    end
  end
end
