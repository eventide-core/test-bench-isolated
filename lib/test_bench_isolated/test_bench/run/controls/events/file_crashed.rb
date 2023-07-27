module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module Events
          module FileCrashed
            extend EventData
  
            def self.example(file: nil, error_message: nil, error_text: nil, process_id: nil, time: nil)
              file ||= self.file
              error_message ||= self.error_message
              error_text ||= self.error_text
              process_id ||= self.process_id
              time ||= self.time
  
              Run::Events::FileCrashed.build(file, error_message, error_text, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.file
              File::Test::Local.example
            end
  
            def self.error_message
              ErrorMessage.example
            end
  
            def self.error_text
              ErrorText.example
            end
  
            def self.process_id
              ProcessID.example
            end
  
            def self.time
              Time.example
            end
  
            module Random
              extend EventData
  
              def self.example(file: nil, error_message: nil, error_text: nil, process_id: nil, time: nil)
                file ||= File::Test::Local.random
                error_message ||= ErrorMessage.random
                error_text ||= ErrorText.random
                process_id ||= ProcessID.random
                time ||= Time.random
  
                FileCrashed.example(file:, error_message:, error_text:, process_id:, time:)
              end
            end
  
            module ErrorText
              def self.example(...)
                exception = Exception.example
  
                exception.full_message
              end
  
              def self.random
                exception = Exception.random
  
                exception.full_message
              end
            end
  
            module ErrorMessage
              def self.example(file: nil, message: nil, exception_class: nil)
                file ||= self.file
  
                backtrace_frame = Exception::Backtrace::Frame.example(file:)
  
                exception = Exception.example(backtrace_frame:, message:, exception_class:)
  
                get(exception)
              end
  
              def self.random
                Random.example
              end
  
              def self.file
                File::Implementation::Local.example
              end
  
              def self.get(exception)
                exception.full_message(order: :top, highlight: false).each_line(chomp: true).first
              end
  
              module Random
                def self.example(...)
                  exception = Exception::Random.example(...)
  
                  ErrorMessage.get(exception)
                end
  
                def self.file
                  File::Implementation::Local.random
                end
              end
            end
          end
        end
      end
    end
  end
end
