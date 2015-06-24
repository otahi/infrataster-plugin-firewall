require 'unit/spec_helper'

module Infrataster
  module Plugin
    # Infrataster plugin firewall
    module Firewall
      describe Transfer do
        before(:all) do
          Infrataster::Server.define(:src, '192.168.33.10')
          Infrataster::Server.define(:dst, '192.168.33.11')
        end
        after(:all)  { Infrataster::Server.clear_defined_servers }
        describe '#reachable?' do
          context 'if @protocol == :icmp' do
            let(:transfer) do
              Transfer.new(server(:src), server(:dst), protocol: :icmp)
            end
            it 'should be true if PING_OK' do
              allow(server(:src).server)
                .to receive(:ssh_exec).and_return('PING_OK')
              expect(transfer.reachable?).to be true
            end
          end
          context 'if @protocol == :tcp' do
            let(:transfer) do
              Transfer.new(server(:src), server(:dst), protocol: :tcp)
            end
            it 'should be true if capture result is OK' do
              allow(server(:src).server).to receive(:ssh_exec).and_return(true)
              allow_any_instance_of(Capture)
                .to receive(:open) { |&block| block.call }
              allow_any_instance_of(Capture)
                .to receive(:result).and_return(true)
              expect(transfer.reachable?).to be true
            end
          end
          context 'if @protocol == :udp' do
            let(:transfer) do
              Transfer.new(server(:src), server(:dst), protocol: :udp)
            end
            it 'should be true if capture result is OK' do
              allow(server(:src).server).to receive(:ssh_exec).and_return(true)
              allow_any_instance_of(Capture)
                .to receive(:open) { |&block| block.call }
              allow_any_instance_of(Capture)
                .to receive(:result).and_return(true)
              expect(transfer.reachable?).to be true
            end
          end
        end
      end
    end
  end
end
