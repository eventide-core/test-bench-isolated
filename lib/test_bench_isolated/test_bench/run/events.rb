module TestBenchIsolated
  module TestBench
    class Run
      module Events
        FileStarted = Telemetry::Event.define(:file)
        FileFinished = Telemetry::Event.define(:file, :result)
        FileCrashed = Telemetry::Event.define(:file, :error_message, :error_text)
  
        Started = Telemetry::Event.define(:random_seed)
        Finished = Telemetry::Event.define(:random_seed, :result)
      end
    end
  end
end
