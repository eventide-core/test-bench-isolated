module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Events
          module ContextStarted
            extend EventData
  
            def self.example(title: nil, process_id: nil, time: nil)
              process_id ||= self.process_id
              time ||= self.time
  
              if title == :none
                title = nil
              else
                title ||= self.title
              end
  
              Session::Events::ContextStarted.build(title, process_id:, time:)
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
  
                ContextStarted.example(title:, process_id:, time:)
              end
            end
  
            module NoTitle
              extend EventData
  
              def self.example(**arguments)
                ContextStarted.example(title: :none, **arguments)
              end
  
              def self.random
                Random.example(title: :none)
              end
            end
          end
        end
      end
    end
  end
end
