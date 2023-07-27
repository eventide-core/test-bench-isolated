module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Events
          module ContextSkipped
            extend EventData
  
            def self.example(title: nil, process_id: nil, time: nil)
              title ||= self.title
              process_id ||= self.process_id
              time ||= self.time
  
              Session::Events::ContextSkipped.build(title, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.title
              Title::Context.example
            end
  
            def self.process_id
              ProcessID.example
            end
  
            def self.time
              Time.example
            end
  
            module Random
              extend EventData
  
              def self.example(title: nil, process_id: nil, time: nil)
                process_id ||= ProcessID.random
                time ||= Time.random
                title ||= Title::Context.random
  
                ContextSkipped.example(title:, process_id:, time:)
              end
            end
          end
        end
      end
    end
  end
end
