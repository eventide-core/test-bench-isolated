module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module Exception
          def self.example(backtrace_frame: nil, message: nil, exception_class: nil)
            exception = Fixture::Controls::Exception.example(message:, exception_class:)
  
            backtrace = Backtrace.example(backtrace_frame)
            exception.set_backtrace(backtrace)
  
            exception
          end
  
          def self.random
            Random.example
          end
  
          def self.message
            Message.example
          end
  
          def self.backtrace_frame
            BacktraceFrame.example
          end
  
          Example = Fixture::Controls::Exception::Example
  
          Message = Fixture::Controls::Exception::Message
  
          module Random
            def self.example(message: nil, backtrace_frame: nil)
              message ||= Message.random
              backtrace_frame ||= Backtrace::Frame.random
  
              Exception.example(message:, backtrace_frame:)
            end
          end
  
          module Backtrace
            def self.example(frame=nil)
              frame ||= self.frame
  
              [frame]
            end
  
            def self.random
              frame = Frame.random
  
              example(frame)
            end
  
            def self.frame
              Frame.example
            end
  
            module Frame
              def self.example(file: nil, line_number: nil, method_name: nil)
                file ||= self.file
                line_number ||= self.line_number
                method_name ||= self.method_name
  
                "#{file}:#{line_number}:in `#{method_name}'"
              end
  
              def self.random
                Random.example
              end
  
              def self.file
                File::Implementation.example
              end
  
              def self.line_number
                11
              end
  
              def self.method_name
                'some_method'
              end
  
              module Random
                def self.example(file: nil, line_number: nil, method_name: nil)
                  file ||= File::Implementation.random
                  line_number ||= Controls::Random.integer
                  method_name ||= self.method_name
  
                  Frame.example(file:, line_number:, method_name:)
                end
  
                def self.method_name
                  suffix = Controls::Random.string
  
                  "#{Frame.method_name}_#{suffix}"
                end
              end
            end
          end
        end
      end
    end
  end
end
