module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Exception
          def self.example(message: nil, exception_class: nil)
            message ||= self.message
            exception_class ||= Example
  
            exception_class.new(message)
          end
  
          def self.other_example
            exception_class = OtherExample
  
            example(exception_class:)
          end
  
          def self.random
            message = Message.random
  
            example(message:)
          end
  
          def self.message
            Message.example
          end
  
          Example = Class.new(RuntimeError)
          OtherExample = Class.new(RuntimeError)
  
          module Message
            def self.example
              "Some exception"
            end
  
            def self.random
              suffix = Random.string
  
              "#{example} #{suffix}"
            end
          end
        end
      end
    end
  end
end
