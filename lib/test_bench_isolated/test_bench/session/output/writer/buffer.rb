module TestBenchIsolated
  module TestBench
    class Session
      class Output
        class Writer
          module Buffer
            def self.configure(receiver, device: nil, experimental_output: nil, attr_name: nil)
              device ||= Defaults.device
              experimental_output ||= Defaults.experimental_output
              attr_name ||= :buffer
  
              if experimental_output
                interactive = device.tty?
              else
                interactive = false
              end
  
              if interactive
                Buffer::Interactive.configure(receiver, device:, attr_name:)
              else
                TestBench::Output::Writer::Buffer.configure(receiver, attr_name:)
              end
            end
          end
        end
      end
    end
  end
end
