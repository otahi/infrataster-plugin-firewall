require 'unit/spec_helper'

module Infrataster
  module Plugin
    # Infrataster plugin firewall
    module Firewall
      describe Util do
        describe 'address' do
          before(:all) { Infrataster::Server.define(:src, '192.168.33.10') }
          after(:all)  { Infrataster::Server.clear_all }

          context 'if node.server is given' do
            let(:node) { server(:src) }
            it 'should respond node.server.addrress' do
              expect(Util.address(node)).to eql(node.server.address)
            end
          end
          context 'if node.server is String' do
            let(:node) { '192.168.33.11' }
            it 'should respond node.to_s' do
              expect(Util.address(node)).to eql(node.to_s)
            end
          end
        end
      end
    end
  end
end
