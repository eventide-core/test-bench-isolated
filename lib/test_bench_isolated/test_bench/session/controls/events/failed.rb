module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Events
          module Failed
            extend EventData
  
            def self.example(message: nil, process_id: nil, time: nil)
              message ||= self.message
              process_id ||= self.process_id
              time ||= self.time
  
              Session::Events::Failed.build(message, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.message
              Failure::Message.example
            end
  
            def self.process_id
              ProcessID.example
            end
  
            def self.time
              Time.example
            end
  
            module Random
              extend EventData
  
              def self.example(message: nil, process_id: nil, time: nil)
                message ||= Failure::Message.random
                process_id ||= ProcessID.random
                time ||= Time.random
  
                Failed.example(message:, process_id:, time:)
              end
            end
          end
        end
      end
    end
  end
end
