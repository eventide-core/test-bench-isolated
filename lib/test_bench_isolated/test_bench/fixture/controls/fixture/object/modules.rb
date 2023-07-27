module TestBenchIsolated
  module TestBench
    module Fixture
      module Controls
        module Fixture
          module Object
            module Modules
              def self.included
                [Extended, Included, NoFixture]
              end
  
              module Included
                def self.example
                  self
                end
  
                module Fixture
                end
              end
  
              module Extended
                def self.example
                  self
                end
  
                module Fixture
                end
              end
  
              module NoFixture
                def self.example
                  self
                end
              end
            end
          end
        end
      end
    end
  end
end
