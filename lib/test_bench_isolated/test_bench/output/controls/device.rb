module TestBenchIsolated
  module TestBench
    module Output
      module Controls
        module Device
          def self.example
            TestBench::Output::Device::Substitute.build
          end
  
          module TTY
            def self.example(tty: nil)
              tty = true if tty.nil?
  
              device = Device.example
              device.tty! if tty
              device
            end
  
            module Non
              def self.example
                TTY.example(tty: false)
              end
            end
          end
        end
      end
    end
  end
end
