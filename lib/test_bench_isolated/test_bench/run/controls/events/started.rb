module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module Events
          module Started
            extend EventData
  
            def self.example(random_seed: nil, process_id: nil, time: nil)
              random_seed ||= self.random_seed
              process_id ||= self.process_id
              time ||= self.time
  
              Run::Events::Started.build(random_seed, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.random_seed
              1
            end
  
            def self.process_id
              ProcessID.example
            end
  
            def self.time
              Time.example
            end
  
            module Random
              extend EventData
  
              def self.example(random_seed: nil, process_id: nil, time: nil)
                random_seed ||= Controls::Random.integer
                process_id ||= ProcessID.random
                time ||= Time.random
  
                Started.example(random_seed:, process_id:, time:)
              end
            end
          end
        end
      end
    end
  end
end
