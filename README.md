# Infrataster::Plugin::Firewall
[![Gem Version](https://badge.fury.io/rb/infrataster-plugin-firewall.svg)](http://badge.fury.io/rb/infrataster-plugin-firewall)
[![Build Status](https://travis-ci.org/otahi/infrataster-plugin-firewall.svg)](https://travis-ci.org/otahi/infrataster-plugin-firewall)
[![Coverage Status](https://coveralls.io/repos/otahi/infrataster-plugin-firewall/badge.png)](https://coveralls.io/r/otahi/infrataster-plugin-firewall)

Firewall plugin for Infrataster.

## Why Infrataster::Plugin::Firewall

We want to test connectivity between a source server and a destination server.
But the servers could not respond because of no service provided on the port which we want to test.
So, this plugin tests tcp/udp with tcpdump which can get packets on destination servers.
Tcpdump can capture packets even if iptables or firewalld drops the packets.

## Usage

The usage is as same as [Infrataster](https://github.com/ryotarai/infrataster).

```ruby
require 'infrataster-plugin-firewall'

describe server(:src) do
  describe firewall(server(:dst)) do
    it { is_expected.to be_reachable } #ICMP ping
    it { is_expected.to be_reachable.dest_port(80) } #TCP:80
    it { is_expected.to be_reachable.tcp.dest_port(80) }
    it { is_expected.to be_reachable.udp.dest_port(53) }
    it { is_expected.to be_reachable.dest_port('80/tcp') }
    it { is_expected.to be_reachable.dest_port('53/udp') }
    it { is_expected.to be_reachable.tcp.dest_port(80).source_port(30123) }
  end
end
```

You can get following result:

```
$ bundle exec rspec

server 'src'
  via firewall
    should reach to server 'dst'
    should reach to server 'dst' dest_port: 80
    should reach to server 'dst' tcp dest_port: 80
    should reach to server 'dst' udp dest_port: 53
    should reach to server 'dst' dest_port: 80/tcp
    should reach to server 'dst' dest_port: 53/udp
    should reach to server 'dst' tcp dest_port: 80 source_port: 30123

Finished in 21.35 seconds (files took 0.7851 seconds to load)
7 examples, 0 failures
$
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'infrataster-plugin-firewall'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install infrataster-plugin-firewall

## Requirement

This plugin uses nc(netcat) and tcpdump.
You need to run tcpdump on destination servers with sudo, 
and nc on source servers.

## Release Notes

[Release Notes](./RELEASE_NOTES.md)

## Contributing

1. Fork it ( https://github.com/otahi/infrataster-plugin-firewall/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
