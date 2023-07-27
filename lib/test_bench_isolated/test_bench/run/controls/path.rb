module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module Path
          def self.example
            File.example
          end
  
          def self.random
            File.random
          end
        end
      end
    end
  end
end
