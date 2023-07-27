module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Events
          module FixtureFinished
            extend EventData
  
            def self.example(name: nil, result: nil, process_id: nil, time: nil)
              name ||= self.name
              result = self.result if result.nil?
              process_id ||= self.process_id
              time ||= self.time
  
              Session::Events::FixtureFinished.build(name, result, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.name
              Fixture::Name.example
            end
  
            def self.result
              Result.example
            end
  
            def self.process_id
              ProcessID.example
            end
  
            def self.time
              Time.example
            end
  
            module Random
              extend EventData
  
              def self.example(name: nil, result: nil, process_id: nil, time: nil)
                name ||= Fixture::Name.random
                result = Result.random if result.nil?
                process_id ||= ProcessID.random
                time ||= Time.random
  
                FixtureFinished.example(name:, result:, process_id:, time:)
              end
            end
          end
        end
      end
    end
  end
end
