module TestBenchIsolated
  module TestBench
    class Telemetry
      module Controls
        module Projection
          def self.example(receiver=nil)
            receiver ||= Receiver.example
  
            Example.new(receiver)
          end
  
          class Example
            include Telemetry::Sink::Projection
  
            attr_accessor :applied_event_data
  
            receiver_name :some_receiver
  
            apply Event::SomeEvent do |some_event|
              receiver.event(some_event)
            end
  
            def apply_event_data(event_data)
              self.applied_event_data = event_data
            end
  
            def applied?(event=nil)
              receiver.event?(event)
            end
  
            def applied_event_data?(event_data)
              self.applied_event_data == event_data
            end
          end
  
          module NoApplyMethod
            def self.example(receiver=nil)
              receiver ||= Receiver.example
  
              Example.new(receiver)
            end
  
            class Example
              include Telemetry::Sink::Projection
            end
          end
  
          module NoArgument
            def self.example(receiver=nil)
              receiver ||= Receiver.example
  
              Example.new(receiver)
            end
  
            class Example
              include Telemetry::Sink::Projection
  
              attr_accessor :applied_event
              def applied? = !!applied_event
  
              apply Event::SomeEvent do
                self.applied_event = true
              end
            end
          end
  
          module ApplyMethod
            def self.example(event_type=nil)
              event_type ||= Event::SomeEvent.event_type
  
              event_name = TestBench::Telemetry::Event::EventName.get(event_type)
  
              :"apply_#{event_name}"
            end
  
            def self.other_example
              event_type = Event::SomeOtherEvent.event_type
  
              example(event_type)
            end
          end
        end
      end
    end
  end
end
