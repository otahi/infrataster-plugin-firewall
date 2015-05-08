require 'unit/spec_helper'

module Infrataster
  # Infrataster Helpers
  module Helpers
    describe ResourceHelper do
      context '#firewall' do
        it 'should respond instance of Resources::FirewallResource' do
          expect(firewall(:dst))
            .to be_a_kind_of(Resources::FirewallResource)
        end
      end
    end
  end
end
