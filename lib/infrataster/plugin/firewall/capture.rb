require 'infrataster-plugin-firewall'

module Infrataster
  module Plugin
    # Infrataster plugin for firewall
    module Firewall
      # Reqresent capture
      class Capture
        Thread.abort_on_exception = true

        attr_reader :result, :output

        def initialize(nodes, bpf = nil, prove = nil, include_str = nil,
                       term_sec = nil)
          @nodes = nodes.respond_to?(:each) ? nodes : [nodes]
          @bpf = bpf ? bpf : ''
          @prove = prove ? prove : ''
          @include_str = include_str
          @term_sec = term_sec ? term_sec : 5
          set_initial_value
        end

        def open
          @nodes.each { |node| open_node(node) }
          wait_connected
        end

        def close
          sleep 0.5 until capture_done?
          @threads.each do |t|
            t.kill
          end
          @ssh.each do |ssh|
            ssh.close unless ssh.closed?
          end
        end

        def self.bpf(options = {})
          is_first = true
          filter = ''

          options.each do |k, v|
            next unless k && v
            filter << ' and ' unless is_first
            filter << k.to_s.gsub('_', ' ') + ' ' + v.to_s
            is_first = false
          end
          filter
        end

        private

        def set_initial_value
          @threads, @ssh, @nodes_connected = [], [], {}
          @result = false
          @output = []
        end

        def open_node(node)
          @threads << Thread.new do
            Net::SSH.start(node, nil, config: true) do |ssh|
              @ssh << ssh
              ssh.open_channel do |channel|
                output = run_check channel
                @output.push(node: node, output: output)
              end
            end
          end
        end

        def wait_connected
          sleep 0.5 until @nodes_connected.length == @nodes.length
        end

        def run_check(channel)
          output = ''
          channel.request_pty do |chan, success|
            fail 'Could not obtain pty' unless success
            output = exec_capture(chan)
          end
          output
        end

        def exec_capture(channel)
          whole_data = ''
          @start_sec = Time.now.to_i + 1
          channel.exec(capture_command) do |ch, _stream, _data|
            receive_data(ch, whole_data)
            break if capture_done?
          end
          capture_command + "\n" + whole_data
        end

        def receive_data(channel, data)
          channel.on_data do |_c, d|
            @nodes_connected.merge!(Thread.current.to_s => true)
            data << d
            @result = match_all?(data)
          end
          data
        end

        def capture_done?
          now_sec = Time.now.to_i
          (@term_sec > 0 && now_sec - @start_sec > @term_sec) ? true : @result
        end

        def match_all?(string)
          patterns = [@prove]
          patterns << @include_str if @include_str
          num_patterns, num_match = 0, 0
          patterns.each do |pat|
            num_patterns += 1
            num_match += 1 if string.match(pat)
          end
          num_match == num_patterns
        end

        def capture_command
          %Q(sudo ngrep -W byline "#{@prove}" #{@bpf} | grep -v "match:")
        end
      end
    end
  end
end
