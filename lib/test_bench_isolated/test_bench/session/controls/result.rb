module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Result
          def self.example
            pass
          end
  
          def self.pass
            true
          end
  
          def self.failure
            false
          end
  
          def self.random
            Random.boolean
          end
        end
      end
    end
  end
end
