module TestBenchIsolated
  module TestBench
    module Output
      def self.included(cls)
        cls.class_exec do
          include Telemetry::Sink::Handler
  
          extend Build
          extend RegisterTelemetry
          extend Configure
        end
      end
  
      def writer
        @writer ||= Writer::Substitute.build
      end
      attr_writer :writer
  
      def configure(writer: nil, device: nil, styling: nil)
        Writer.configure(self, writer:, device:, styling:)
      end
  
      module Build
        def build(writer: nil, device: nil, styling: nil, **arguments)
          instance = new
          instance.configure(writer:, device:, styling:, **arguments)
          instance
        end
      end
  
      module RegisterTelemetry
        def register_telemetry(telemetry, **arguments)
          instance = build(**arguments)
          telemetry.register(instance)
          instance
        end
        alias :register :register_telemetry
      end
  
      module Configure
        def configure(receiver, attr_name: nil, **arguments)
          attr_name ||= :output
  
          instance = build(**arguments)
          receiver.public_send(:"#{attr_name}=", instance)
        end
      end
  
      module Substitute
        def self.build
          Output.new
        end
  
        class Output < Telemetry::Substitute::Sink
          def handle(event_or_event_data)
            if event_or_event_data.is_a?(Telemetry::Event)
              event_data = Telemetry::Event::Export.(event_or_event_data)
            else
              event_data = event_or_event_data
            end
  
            receive(event_data)
          end
        end
      end
    end
  end
end
