module TestBenchIsolated
  module TestBench
    class Telemetry
      module Controls
        module Event
          module EventData
            def event_data
              event = self.example
  
              Telemetry::Event::Export.(event)
            end
          end
        end
      end
    end
  end
end
