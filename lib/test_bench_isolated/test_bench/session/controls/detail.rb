module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Detail
          module Text
            def self.example
              "Some detail"
            end
  
            def self.random
              Random.example
            end
  
            module Random
              def self.example(suffix=nil, text: nil)
                text ||= Text.example
  
                Comment::Text::Random.example(suffix, text:)
              end
            end
  
            module MultipleLines
              def self.example(lines=nil)
                lines ||= self.lines
  
                Comment::Text::MultipleLines.example(lines)
              end
  
              def self.random
                Random.example
              end
  
              def self.lines
                [
                  "Some detail",
                  "Some other detail",
                  "Yet another detail"
                ]
              end
  
              module Random
                def self.example(suffix=nil)
                  suffix ||= Comment::Text::Random.suffix
  
                  lines = MultipleLines.lines.map do |line|
                    Text::Random.example(suffix, text: line)
                  end
                end
              end
            end
          end
  
          module Heading
            def self.example(text: nil)
              text ||= self.text
  
              "#{text}:"
            end
  
            def self.random
              Random.example
            end
  
            def self.text
              "Some Detail Heading"
            end
  
            module Random
              def self.example(suffix=nil)
                suffix ||= Controls::Random.string
  
                text = "#{Heading.text} #{suffix}"
  
                Heading.example(text:)
              end
            end
          end
  
          module Quote
            def self.example
              true
            end
  
            def self.random
              Random.boolean
            end
          end
        end
      end
    end
  end
end
