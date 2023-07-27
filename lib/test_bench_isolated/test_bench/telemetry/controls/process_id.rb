module TestBenchIsolated
  module TestBench
    class Telemetry
      module Controls
        module ProcessID
          def self.example
            11111
          end
  
          def self.other_example
            22222
          end
  
          def self.random
            Random.integer
          end
        end
      end
    end
  end
end
