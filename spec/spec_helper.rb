require 'infrataster/rspec'

Infrataster::Server.define(:src) do |server|
  server.address = '192.168.33.10/32'
  server.vagrant = true
end
Infrataster::Server.define(:dst) do |server|
  server.address = '192.168.33.11/32'
  server.vagrant = true
end
