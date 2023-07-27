module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Output
          Device = TestBench::Output::Controls::Device
          Data = TestBench::Output::Controls::Data
          Styling = TestBench::Output::Controls::Styling
          Style = TestBench::Output::Controls::Style
          Text = TestBench::Output::Controls::Text
  
          def self.example(details: nil, styling: nil, mode: nil)
            styling ||= false
  
            output = Session::Output.new
  
            if details == true
              output.detail_policy = Session::Output::Detail.on
            elsif details == false
              output.detail_policy = Session::Output::Detail.off
            else
              output.detail_policy = Session::Output::Detail.failure
            end
  
            if styling
              output.writer.styling!
            end
  
            if not mode.nil?
              output.mode = mode
            end
  
            output
          end
  
          module Styling
            def self.example
              Output.example(styling:)
            end
  
            def self.styling
              true
            end
          end
  
          module Pending
            def self.example
              output = Styling.example
              output.pending_writer.buffer.limit = nil
              output
            end
          end
        end
      end
    end
  end
end
