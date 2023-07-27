module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Comment
          module Text
            def self.example
              "Some comment"
            end
  
            def self.random
              Random.example
            end
  
            module Random
              def self.example(suffix=nil, text: nil)
                suffix ||= self.suffix
                text ||= Text.example
  
                "#{text} #{suffix}"
              end
  
              def self.suffix
                Controls::Random.string
              end
            end
  
            module MultipleLines
              def self.example(lines=nil)
                lines ||= self.lines
  
                text = String.new
  
                lines.map do |line|
                  text << line
                  text << "\n"
                end
  
                text
              end
  
              def self.random
                Random.example
              end
  
              def self.lines
                [
                  "Some comment",
                  "Some other comment",
                  "Yet another comment"
                ]
              end
  
              module Random
                def self.example(suffix=nil)
                  suffix ||= Text::Random.suffix
  
                  lines = MultipleLines.lines.map do |line|
                    Text::Random.example(suffix, text: line)
                  end
  
                  MultipleLines.example(lines)
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
              "Some Comment Heading"
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
