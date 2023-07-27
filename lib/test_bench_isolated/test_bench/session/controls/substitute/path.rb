module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Substitute
          module Path
            def self.example(segments=nil)
              segments ||= Segment.examples
  
              segments = segments.dup
  
              path = TestBench::Session::Substitute::Path.new
              path.segments = segments
              path
            end
  
            module Segment
              def self.examples
                [example, Context.other_example, Test.example]
              end
  
              def self.example
                Context.example
              end
  
              Test = Title::Test
  
              Context = Title::Context
            end
          end
        end
      end
    end
  end
end
