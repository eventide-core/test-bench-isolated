module TestBenchIsolated
  module TestBench
    module Fixture
      module Controls
        module Fixture
          def self.example
            Example.new
          end
  
          def self.call(output=nil, &block)
            output ||= Output.example
  
            fixture = Example.new
  
            fixture.test_session.telemetry.register(output)
  
            block.(fixture)
  
            fixture
          end
  
          class Example
            include TestBench::Fixture
          end
        end
      end
    end
  end
end
