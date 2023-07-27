module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module Executor
          def self.example
            Example.new
          end
  
          class Example
            include TestBench::Run::Executor
  
            attr_accessor :executed_file
  
            attr_accessor :started
            def started? = !!started
  
            attr_accessor :finished
            def finished? = !!finished
  
            attr_accessor :configured
            def configured? = !!configured
  
            def configure
              self.configured = true
            end
  
            def start
              self.started = true
            end
  
            def execute(file)
              self.executed_file = file
            end
  
            def executed?(file)
              executed_file == file
            end
  
            def finish
              self.finished = true
            end
          end
  
          module NotImplemented
            def self.example
              Example.new
            end
  
            class Example
              include TestBench::Run::Executor
            end
          end
        end
      end
    end
  end
end
