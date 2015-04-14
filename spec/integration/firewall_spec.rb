require 'spec_helper'

describe server(:src) do
  describe firewall(server(:dst)) do
    it { is_expected.to be_reachable }
    it { is_expected.to be_reachable.dest_port(80) }
    it { is_expected.to be_reachable.tcp.dest_port(80) }
    it { is_expected.to be_reachable.udp.dest_port(53) }
  end
end
