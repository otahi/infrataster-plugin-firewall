# Not Released Yet

# Infrataster::Plugin::Firewall
[![Gem Version](https://badge.fury.io/rb/infrataster-plugin-firewall.svg)](http://badge.fury.io/rb/infrataster-plugin-firewall)
[![Build Status](https://travis-ci.org/otahi/infrataster-plugin-firewall.svg)](https://travis-ci.org/otahi/infrataster-plugin-firewall)
[![Coverage Status](https://coveralls.io/repos/otahi/infrataster-plugin-firewall/badge.png)](https://coveralls.io/r/otahi/infrataster-plugin-firewall)

Firewall plugin for Infrataster.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'infrataster-plugin-firewall'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install infrataster-plugin-firewall

## Usage

The usage is as same as [Infrataster](https://github.com/ryotarai/infrataster).

```ruby
require 'infrataster-plugin-firewall'

describe server(:source) do
  it { is_expected.to reach_to(server(:dest)) } #ICMP ping
  it { is_expected.to reach_to(server(:dest)).dest_port(80) } #TCP:80
  it { is_expected.to reach_to(server(:dest)).tcp.dest_port(80) }
  it { is_expected.to reach_to(server(:dest)).udp.dest_port(53) }
  it { is_expected.to reach_to(server(:dest)).udp.dest_port(53) }
  it { is_expected.to reach_to(server(:dest)).tcp.dest_port(80).source_port(30123) }
end
```

You can get following result:

```
$ bundle exec rspec

server 'source'
  should reach to server 'dest'
  should reach to server 'dest' port 80
  should reach to server 'dest' port 80/tcp
  should reach to server 'dest' port 53/udp
  should reach to server 'dest' port 80/tcp from port 30123

Finished in 10.03599 seconds (files took 0.93903 seconds to load)
5 examples, 0 failures
$
```


## Contributing

1. Fork it ( https://github.com/otahi/infrataster-plugin-firewall/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
