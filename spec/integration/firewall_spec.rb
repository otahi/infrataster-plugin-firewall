require 'spec_helper'

describe server(:src) do
  describe firewall(server(:dst)) do
    it { is_expected.to be_reachable }
  end
end
