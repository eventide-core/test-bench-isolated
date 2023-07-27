module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Fixture
          module Name
            def self.example
              "SomeNamespace::SomeFixture"
            end
  
            def self.random
              suffix = Random.string
  
              "#{example}_#{suffix}"
            end
          end
        end
      end
    end
  end
end
