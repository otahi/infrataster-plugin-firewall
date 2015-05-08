require 'unit/spec_helper'

module Infrataster
  # Infrataster Resources
  module Resources
    describe FirewallResource do
      let(:resource) { FirewallResource.new(:src, :dst) }

      describe '#to_s' do
        it 'should respond "via firewall"' do
          expect(resource.to_s).to eql('via firewall')
        end
      end
      describe '#src_node' do
        it 'should respond first argument for initializing' do
          expect(resource.src_node).to eql(:src)
        end
      end
      describe '#dest_node' do
        it 'should respond second argument for initializing' do
          expect(resource.dest_node).to eql(:dst)
        end
      end
    end
  end
end
