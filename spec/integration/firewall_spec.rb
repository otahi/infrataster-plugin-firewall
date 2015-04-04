require 'spec_helper'

describe server(:src) do
  it { is_expected.to reach_to(server(:dst)) }
end
