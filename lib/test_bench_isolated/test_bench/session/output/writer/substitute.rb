module TestBenchIsolated
  module TestBench
    class Session
      class Output
        class Writer
          module Substitute
            def self.build
              Writer.build
            end
  
            class Writer < Writer
              include TestBench::Output::Writer::Substitute
            end
          end
        end
      end
    end
  end
end
