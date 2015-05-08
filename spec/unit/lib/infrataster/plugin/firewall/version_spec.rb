require 'unit/spec_helper'

module Infrataster
  # Infrataster plugin
  module Plugin
    describe Firewall do
      it 'should have VERSION like 0.1.1' do
        expect(Infrataster::Plugin::Firewall::VERSION)
          .to match(/^\d+\.\d+\.\d+$/)
      end
    end
  end
end
