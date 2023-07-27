module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Events
          def self.examples(random: nil)
            random ||= false
  
            events = []
  
            Session::Events.each_type do |event_type|
              control = Events.const_get(event_type, false)
  
              if random
                event = control.random
              else
                event = control.example
              end
  
              events << event
            end
  
            events
          end
  
          def self.each_example(random: nil, &block)
            examples = examples(random:)
  
            examples.each(&block)
          end
        end
      end
    end
  end
end
