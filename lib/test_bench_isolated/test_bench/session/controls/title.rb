module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Title
          module Context
            def self.example
              "Some Context"
            end
  
            def self.other_example
              "Some Other Context"
            end
  
            def self.random
              suffix = Random.string
  
              "#{example} #{suffix}"
            end
          end
  
          module Test
            def self.example
              "Some test"
            end
  
            def self.other_example
              "Some other test"
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
