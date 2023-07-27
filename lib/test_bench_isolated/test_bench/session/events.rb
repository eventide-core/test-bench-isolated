module TestBenchIsolated
  module TestBench
    class Session
      module Events
        def self.each_type(&block)
          constants(false).each(&block)
        end
  
        Failed = TestBench::Telemetry::Event.define(:message)
  
        ContextStarted = TestBench::Telemetry::Event.define(:title)
        ContextFinished = TestBench::Telemetry::Event.define(:title, :result)
        ContextSkipped = TestBench::Telemetry::Event.define(:title)
  
        TestStarted = TestBench::Telemetry::Event.define(:title)
        TestFinished = TestBench::Telemetry::Event.define(:title, :result)
        TestSkipped = TestBench::Telemetry::Event.define(:title)
  
        Commented = TestBench::Telemetry::Event.define(:text, :quote, :heading)
        Detailed = TestBench::Telemetry::Event.define(:text, :quote, :heading)
  
        FixtureStarted = TestBench::Telemetry::Event.define(:name)
        FixtureFinished = TestBench::Telemetry::Event.define(:name, :result)
      end
    end
  end
end
