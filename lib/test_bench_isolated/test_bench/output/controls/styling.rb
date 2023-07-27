module TestBenchIsolated
  module TestBench
    module Output
      module Controls
        module Styling
          def self.example
            Writer::Styling.on
          end
  
          def self.other_example
            Writer::Styling.off
          end
  
          def self.random
            stylings = [
              Writer::Styling.on,
              Writer::Styling.off,
              Writer::Styling.detect
            ]
  
            index = Random.integer % stylings.count
  
            stylings[index]
          end
        end
      end
    end
  end
end
