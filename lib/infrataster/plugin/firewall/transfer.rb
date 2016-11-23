module Infrataster
  module Plugin
    # Infrataster plugin for firewall
    module Firewall
      # Represent transfer
      class Transfer
        def initialize(src_node, dest_node, options = {})
          @src_node = src_node
          @dest_node = dest_node
          @protocol = options[:protocol] ? options[:protocol] : :icmp
          @dest_port = options[:dest_port] ? options[:dest_port] : 80
          @source_port = options[:source_port] ? options[:source_port] : nil
          @ack = options[:ack] ? options[:ack] : nil
          @interface = options[:interface] ? options[:interface] : nil
        end

        def reachable?
          case @protocol
          when :icmp
            icmp_reachable?
          when :tcp, :udp
            transport_reachable?
          end
        end

        private

        def icmp_reachable?
          dest_addr = Util.address(@dest_node)
          uname = @src_node.server.ssh_exec('uname -s')
          ping_options = '-c 1 -w 3'
          case uname.chomp
          when 'FreeBSD'
            ping_options = '-c 1 -t 3'
          end
          @src_node.server
            .ssh_exec("ping #{ping_options} #{dest_addr} && echo PING_OK")
            .include?('PING_OK')
        end

        def transport_reachable?
          if @protocol == :tcp && @ack == :only
            jugde_with_only_ack
          else
            jugde_with_capture
          end
        end

        def jugde_with_only_ack
          dest_addr = Util.address(@dest_node)

          nc_result =
            @src_node.server
            .ssh_exec('echo test_with_infrataster | ' \
                      + "nc #{dest_addr} #{@dest_port} #{nc_options}" \
                      '&& echo NC_OK')
          nc_result.to_s.include?('NC_OK')
        end

        def jugde_with_capture
          src_addr = Util.address(@src_node)
          dest_addr = Util.address(@dest_node)

          bpf = Capture.bpf(bpf_options(src_addr, dest_addr))
          capture = Capture.new(@dest_node, bpf, @interface)
          nc_result = nil
          capture.open do
            nc_result =
              @src_node.server
              .ssh_exec('echo test_with_infrataster | ' \
                        + "nc #{dest_addr} #{@dest_port} #{nc_options}" \
                        '&& echo NC_OK')
          end
          capture_succedded?(capture.result, nc_result)
        end

        def capture_succedded?(capture_result, nc_result)
          if @protocol == :tcp && @ack == :both
            capture_result && nc_result.to_s.include?('NC_OK')
          else
            capture_result
          end
        end

        def nc_options
          nc_option = @protocol == :udp ? '-w1 -u' : '-w1 -t'
          nc_option + (@source_port ? " -p #{@source_port}" : '')
        end

        def bpf_options(src_addr, dest_addr)
          options = { :'src host' => src_addr,
                      :'dst host' => dest_addr,
                      :'dst port' => @dest_port,
                      @protocol.downcase => nil }
          options.merge!(:'src port' => @source_port) if @source_port
          options
        end
      end
    end
  end
end
