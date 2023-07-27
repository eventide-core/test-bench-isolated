module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module Events
          module Finished
            extend EventData
  
            def self.example(result: nil, random_seed: nil, process_id: nil, time: nil)
              random_seed ||= self.random_seed
              result = self.result if result.nil?
              process_id ||= self.process_id
              time ||= self.time
  
              Run::Events::Finished.build(random_seed, result, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.random_seed
              Started.random_seed
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
  
              def self.example(result: nil, random_seed: nil, process_id: nil, time: nil)
                random_seed ||= Controls::Random.integer
                process_id ||= ProcessID.random
                time ||= Time.random
  
                if result.nil?
                  result = Result.random
                end
  
                Finished.example(result:, random_seed:, process_id:, time:)
              end
            end
          end
        end
      end
    end
  end
end
