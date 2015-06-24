require 'unit/spec_helper'

module Infrataster
  module Plugin
    # Infrataster plugin firewall
    module Firewall
      describe Capture do
        before(:all) do
          Infrataster::Server.define(:src, '192.168.33.10')
          Infrataster::Server.define(:dst, '192.168.33.11')
        end
        after(:all)  { Infrataster::Server.clear_defined_servers }
        describe '#open' do
          let(:capture) do
            ssh  = double('ssh')
            allow(ssh).to receive(:open_channel)
            allow(ssh).to receive(:closed?).and_return(false)
            node = double('node')
            allow(node).to receive(:server).and_return(ssh)
            allow(node).to receive(:ssh).and_yield(ssh)
            capture = Capture.new(node)
            capture.instance_variable_set(:@ssh, ssh)
            capture
          end
          context 'block given' do
            it 'should call block with closing' do
              capture.instance_variable_set(:@connected, true)
              capture.instance_variable_set(:@start_sec, 0)
              allow(capture).to receive(:run_check).and_return(true)
              result = nil
              expect(capture).to receive(:close).once
              capture.open { result = true }
              expect(result).to be true
            end
          end
          context 'no block given' do
            it 'should call block without closing' do
              capture.instance_variable_set(:@connected, true)
              capture.instance_variable_set(:@start_sec, 0)
              allow(capture).to receive(:run_check).and_return(true)
              expect(capture).not_to receive(:close)
              capture.open
            end
          end
        end
      end
    end
  end
end
