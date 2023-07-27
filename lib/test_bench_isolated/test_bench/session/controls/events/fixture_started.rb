module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Events
          module FixtureStarted
            extend EventData
  
            def self.example(name: nil, process_id: nil, time: nil)
              name ||= self.name
              process_id ||= self.process_id
              time ||= self.time
  
              Session::Events::FixtureStarted.build(name, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.name
              Fixture::Name.example
            end
  
            def self.process_id
              ProcessID.example
            end
  
            def self.time
              Time.example
            end
  
            module Random
              extend EventData
  
              def self.example(name: nil, process_id: nil, time: nil)
                name ||= Fixture::Name.random
                process_id ||= ProcessID.random
                time ||= Time.random
  
                FixtureStarted.example(name:, process_id:, time:)
              end
            end
          end
        end
      end
    end
  end
end
