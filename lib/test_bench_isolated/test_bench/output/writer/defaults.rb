module TestBenchIsolated
  module TestBench
    module Output
      class Writer
        module Defaults
          def self.device
            STDOUT
          end
        end
      end
    end
  end
end
