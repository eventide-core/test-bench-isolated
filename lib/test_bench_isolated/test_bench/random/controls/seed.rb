module TestBenchIsolated
  module TestBench
    class Random
      module Controls
        module Seed
          def self.example
            0x1111_1111_1111_1111
          end
  
          def self.text
            example.to_s(36)
          end
  
          module Namespace
            def self.example
              'some-seed-namespace'
            end
  
            def self.other_example
              'some-other-seed-namespace'
            end
          end
        end
      end
    end
  end
end
