module TestBenchIsolated
  module TestBench
    class Telemetry
      module Controls
        module Projection
          module Receiver
            def self.example
              Example.new
            end
  
            class Example
              def events
                @events ||= []
              end
  
              def event(event)
                events << event
              end
  
              def event?(event=nil)
                if not event.nil?
                  events.include?(event)
                else
                  events.any?
                end
              end
            end
          end
        end
      end
    end
  end
end
