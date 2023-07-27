module TestBenchIsolated
  module TestBench
    module Output
      class Writer
        def device
          @device ||= Device::Substitute.build
        end
        attr_writer :device
  
        def styling_policy
          @styling_policy ||= Styling.default
        end
        alias :styling :styling_policy
        attr_writer :styling_policy
  
        def digest
          @digest ||= Digest.new
        end
        attr_writer :digest
  
        def sequence
          @sequence ||= 0
        end
        attr_writer :sequence
  
        def column_sequence
          @column_sequence ||= 0
        end
        attr_writer :column_sequence
  
        def buffer
          @buffer ||= Buffer.new
        end
        attr_writer :buffer
  
        def configure
          Buffer.configure(self)
        end
  
        def self.build(device=nil, styling: nil, inert_digest: nil)
          device ||= Defaults.device
  
          instance = new
          instance.device = device
          instance.styling_policy = styling
  
          Digest.configure(instance, inert: inert_digest)
  
          instance.configure
  
          instance
        end
  
        def self.configure(receiver, writer: nil, styling: nil, inert_digest: nil, device: nil, attr_name: nil)
          attr_name ||= :writer
  
          if not writer.nil?
            instance = writer
          else
            instance = build(device, styling:, inert_digest:)
          end
  
          receiver.public_send(:"#{attr_name}=", instance)
        end
  
        def sync
          @sync.nil? ? @sync = true : @sync
        end
  
        def tty
          @tty.nil? ? @tty = device_tty? : @tty
        end
        attr_writer :tty
        alias :tty? :tty
  
        def puts(text=nil)
          if not text.nil?
            text = text.chomp
  
            print(text)
          end
  
          style(:reset)
  
          if tty?
            write("\e[0K")
          end
  
          write("\n")
  
          self.column_sequence = 0
        end
  
        def style(style, *additional_styles)
          control_code = Style.control_code(style)
          control_codes = [control_code]
  
          additional_styles.each do |style|
            control_code = Style.control_code(style)
            control_codes << control_code
          end
  
          if styling?
            write("\e[#{control_codes.join(';')}m")
          end
  
          self
        end
  
        def print(text)
          self.column_sequence += text.length
  
          write(text)
  
          self
        end
  
        def write(data)
          if sync
            bytes_written = write!(data)
          else
            bytes_written = buffer.receive(data)
          end
  
          self.sequence += bytes_written
  
          data = data[0...bytes_written]
          digest.update(data)
  
          bytes_written
        end
  
        def write!(data)
          device.write(data)
  
          data.bytesize
        end
  
        def device_tty?
          device.tty?
        end
  
        def flush
          buffer.flush(device)
        end
  
        def sync=(sync)
          @sync = sync
  
          if sync
            flush
          end
        end
  
        def written?(data=nil)
          if data.nil?
            sequence > 0
          else
            digest.digest?(data)
          end
        end
  
        def current?(sequence)
          sequence >= self.sequence
        end
  
        def styling?
          Styling.styling?(styling_policy, tty?)
        end
  
        module Styling
          Error = Class.new(RuntimeError)
  
          def self.styling?(policy, console)
            assure_styling(policy, console)
          end
  
          def self.assure_styling(policy, console=nil)
            console ||= false
  
            case policy
            when on
              true
            when off
              false
            when detect
              console ? true : false
            else
              raise Error, "Unknown styling policy #{policy.inspect}"
            end
          end
  
          def self.on = :on
          def self.off = :off
          def self.detect = :detect
  
          def self.default
            policy = ENV.fetch('TEST_BENCH_OUTPUT_STYLING') do
              return default!
            end
  
            policy.to_sym
          end
  
          def self.default!
            :detect
          end
        end
      end
    end
  end
end
