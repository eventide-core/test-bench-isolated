module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Events
          module Detailed
            extend EventData
  
            def self.example(text: nil, quote: nil, heading: nil, process_id: nil, time: nil)
              quote = self.quote if quote.nil?
              process_id ||= self.process_id
              time ||= self.time
  
              if text == :none
                text = nil
              else
                text ||= self.text
              end
  
              Session::Events::Detailed.build(text, quote, heading, process_id:, time:)
            end
  
            def self.random
              Random.example
            end
  
            def self.text
              Detail::Text.example
            end
  
            def self.quote
              false
            end
  
            def self.process_id
              ProcessID.example
            end
  
            def self.time
              Time.example
            end
  
            module Random
              extend EventData
  
              def self.example(text: nil, quote: nil, heading: nil, process_id: nil, time: nil)
                text ||= Detail::Text.random
                quote ||= Detail::Quote.random
                process_id ||= ProcessID.random
                time ||= Time.random
  
                Detailed.example(text:, quote:, heading:, process_id:, time:)
              end
            end
  
            module MultipleLines
              extend EventData
  
              def self.example(omit_heading: nil, heading: nil, **attributes)
                if omit_heading.nil?
                  omit_heading = !heading.nil?
                end
  
                if not omit_heading
                  heading ||= self.heading
                end
  
                Detailed.example(text:, quote:, heading:, **attributes)
              end
  
              def self.random
                Random.example
              end
  
              def self.text
                Detail::Text::MultipleLines.example
              end
  
              def self.quote
                true
              end
  
              def self.heading
                Detail::Heading.example
              end
  
              module Random
                extend EventData
  
                def self.example(omit_heading: nil, heading: nil, **attributes)
                  if omit_heading.nil?
                    omit_heading = !heading.nil?
                  end
  
                  suffix = Controls::Random.string
  
                  if not omit_heading
                    heading = Detail::Heading::Random.example(suffix)
                  end
  
                  text = Detail::Text::MultipleLines::Random.example(suffix)
  
                  Detailed::Random.example(text:, heading:, **attributes)
                end
              end
            end
          end
        end
      end
    end
  end
end
