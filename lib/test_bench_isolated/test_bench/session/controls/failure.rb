module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Failure
          module Message
            def self.example
              "Some failure message"
            end
  
            def self.random
              suffix = Random.string
  
              "#{example} #{suffix}"
            end
          end
        end
      end
    end
  end
end
