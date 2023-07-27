module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module Events
          module FileStarted
            extend EventData
  
            def self.example(file: nil, process_id: nil, time: nil)
              file ||= self.file
              process_id ||= self.process_id
              time ||= self.time
  
              Run::Events::FileStarted.build(file, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.file
              File::Test::Local.example
            end
  
            def self.process_id
              ProcessID.example
            end
  
            def self.time
              Time.example
            end
  
            module Random
              extend EventData
  
              def self.example(file: nil, process_id: nil, time: nil)
                file ||= File::Test::Local.random
                process_id ||= ProcessID.random
                time ||= Time.random
  
                FileStarted.example(file:, process_id:, time:)
              end
            end
          end
        end
      end
    end
  end
end
