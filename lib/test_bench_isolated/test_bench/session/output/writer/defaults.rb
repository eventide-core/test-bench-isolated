module TestBenchIsolated
  module TestBench
    class Session
      class Output
        class Writer
          module Defaults
            def self.device
              TestBench::Output::Writer::Defaults.device
            end
  
            def self.experimental_output
              ENV.fetch('TEST_BENCH_EXPERIMENTAL_OUTPUT', 'off') == 'on'
            end
          end
        end
      end
    end
  end
end
