module TestBenchIsolated
  module TestBench
    module Fixture
      module Controls
        module Fixture
          module Class
            Example = Fixture::Example
  
            class BuildMethod
              include TestBench::Fixture
  
              attr_accessor :some_argument
              attr_accessor :some_keyword_argument
  
              def self.build(some_argument=nil, some_keyword_argument: nil)
                instance = new
                instance.some_argument = some_argument
                instance.some_keyword_argument = some_keyword_argument
                instance
              end
            end
  
            class NoBuildMethod
              include TestBench::Fixture
  
              attr_reader :some_argument
              attr_reader :some_keyword_argument
  
              def initialize(some_argument=nil, some_keyword_argument: nil)
                @some_argument = some_argument
                @some_keyword_argument = some_keyword_argument
              end
            end
  
            class TestBlock
              include TestBench::Fixture
  
              attr_reader :test_block
  
              def initialize(&test_block)
                @test_block = test_block
              end
  
              NoBuildMethod = TestBlock
  
              class BuildMethod
                include TestBench::Fixture
  
                attr_reader :test_block
  
                def initialize(test_block)
                  @test_block = test_block
                end
  
                def self.build(&test_block)
                  new(test_block)
                end
              end
  
              None = Fixture::Class::BuildMethod
            end
  
            class Actuator
              include TestBench::Fixture
  
              attr_accessor :actuated
              def actuated? = !!actuated
  
              def call
                self.actuated = true
              end
  
              class TestBlock < Actuator
                attr_reader :test_block
  
                def initialize(&test_block)
                  @test_block = test_block
                end
              end
            end
  
            NoActuator = Example
          end
        end
      end
    end
  end
end
