module TestBenchIsolated
  module TestBench
    class Telemetry
      module Controls
        module EventData
          def self.example(type: nil, process_id: nil, time: nil, data: nil)
            type ||= self.type
            process_id ||= self.process_id
            time ||= self.time
            data ||= self.data
  
            event_data = Telemetry::EventData.new
            event_data.type = type
            event_data.process_id = process_id
            event_data.time = time
            event_data.data = data
            event_data
          end
  
          def self.random
            Random.example
          end
  
          def self.type
            Type.example
          end
  
          def self.process_id
            ProcessID.example
          end
  
          def self.time
            Time.example
          end
  
          def self.data
            Data.example
          end
  
          module Random
            def self.example(type: nil, process_id: nil, time: nil, data: nil)
              type ||= Type.random
              process_id ||= ProcessID.random
              time ||= Time.random
              data ||= Data.random
  
              EventData.example(type:, process_id:, time:, data:)
            end
          end
  
          module Type
            def self.example
              :SomeEvent
            end
  
            def self.other_example
              :SomeOtherEvent
            end
  
            def self.random
              :"#{example}#{Controls::Random.string}"
            end
          end
  
          module Data
            def self.example
              [
                nil,
                true,
                false,
                11,
                'some-string',
                Time.example
              ]
            end
  
            def self.random
              [
                nil,
                Controls::Random.boolean,
                Controls::Random.boolean,
                Controls::Random.integer,
                Controls::Random.string,
                Time.random
              ]
            end
          end
  
          module Text
            def self.example(type: nil, process_id: nil, time: nil)
              type ||= EventData.type
              process_id ||= EventData.process_id
              time ||= EventData.time
  
              time_iso8601 = Time::ISO8601.example(time)
  
              "#{type}\t#{process_id}\t#{time_iso8601}\t\ttrue\tfalse\t11\t\"some-string\"\t#{time_iso8601}\r\n"
            end
  
            module Malformed
              module Empty
                def self.example
                  ''
                end
              end
  
              module IncorrectEventType
                def self.example
                  Text.example(type:)
                end
  
                def self.type
                  :not_pascal_cased
                end
              end
  
              module IncorrectNewlines
                def self.example
                  text = Text.example
                  text.chomp!("\r\n")
                  text << "\n"
                  text
                end
              end
            end
          end
        end
      end
    end
  end
end
