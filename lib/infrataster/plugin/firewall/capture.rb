module Infrataster
  module Plugin
    # Infrataster plugin for firewall
    module Firewall
      # Reqresent capture
      class Capture
        attr_reader :result, :output

        def initialize(node, bpf = nil, interface = nil, term_sec = 3)
          @node = node.respond_to?(:server) ? node.server :
            Net::SSH.start(node, config: true)
          @bpf = bpf
          @interface = interface ? interface : 'any'
          @connected = false
          @term_sec = term_sec
          @thread = nil
          @ssh = nil
          @result = false
          @output = ''
        end

        def open(&block)
          open_node
          wait_connected
          return unless block

          block.call
          close
        end

        def close
          sleep 0.5 until capture_done?
          @thread.kill
          @ssh.close unless @ssh.closed?
        end

        def self.bpf(options = {})
          is_first = true
          filter = ''

          options.each do |k, v|
            filter << ' and ' unless is_first
            filter << "#{k} #{v}"
            is_first = false
          end
          filter
        end

        private

        def open_node
          @thread = Thread.new do
            @node.ssh do |ssh|
              @ssh = ssh
              ssh.open_channel do |channel|
                output = run_check(channel)
                @output << output.to_s
              end
            end
          end
        end

        def wait_connected
          sleep 0.5 until @connected
          sleep 1 # after connected wait for tcpdump ready
        end

        def run_check(channel)
          channel.request_pty do |chan, success|
            fail 'Could not obtain pty' unless success
            exec_capture(chan)
          end
        end

        def exec_capture(channel)
          @start_sec = Time.now.to_i + 1
          channel.exec(capture_command) do |ch, _stream, _data|
            receive_data(ch)
            break if capture_done?
          end
        end

        def receive_data(channel)
          data = ''
          channel.on_data do |_c, d|
            @connected = true
            data << d
            @result = data.include?('RECEIVED')
          end
        end

        def capture_done?
          now_sec = Time.now.to_i
          (@term_sec > 0 && now_sec - @start_sec > @term_sec) ? true : @result
        end

        def capture_command
          "sudo tcpdump -c1 -nnn -i #{@interface} #{@bpf} > /dev/null && echo RECEIVED"
        end
      end
    end
  end
end
