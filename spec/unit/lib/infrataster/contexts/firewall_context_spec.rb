require 'unit/spec_helper'

module Infrataster
  # Infrataster contexts
  module Contexts
    describe FirewallContext do
      let(:context) do
        Infrataster::Contexts::FirewallContext.new(nil, nil)
      end
      it 'should have matcher `be_reachable`' do
        expect(context).to respond_to(:be_reachable)
      end
      it 'should have chain `icmp`' do
        expect(context.be_reachable).to respond_to(:icmp)
      end
      it 'should have chain `tcp`' do
        expect(context.be_reachable).to respond_to(:tcp)
      end
      it 'should have chain `udp`' do
        expect(context.be_reachable).to respond_to(:udp)
      end
      it 'should have chain `dest_port`' do
        expect(context.be_reachable).to respond_to(:dest_port)
      end
      it 'should have chain `source_port`' do
        expect(context.be_reachable).to respond_to(:source_port)
      end
      it 'should have failure_message' do
        expect(context.be_reachable)
          .to respond_to(:failure_message)
      end
      it 'should have failure_message_when_negated' do
        expect(context.be_reachable)
          .to respond_to(:failure_message_when_negated)
      end
    end
  end
end
