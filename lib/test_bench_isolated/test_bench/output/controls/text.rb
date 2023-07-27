module TestBenchIsolated
  module TestBench
    module Output
      module Controls
        module Text
          def self.example
            "Some text"
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
