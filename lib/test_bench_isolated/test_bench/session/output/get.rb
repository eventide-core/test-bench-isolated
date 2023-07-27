module TestBenchIsolated
  module TestBench
    class Session
      class Output
        module Get
          def self.call(substitute_session, styling: nil)
            styling = true if styling.nil?
  
            session_sink = substitute_session.sink
  
            output = Output.new
  
            if styling
              output.writer.styling!
            end
  
            session_sink.records.each do |record|
              event_data = record.event_data
  
              output.receive(event_data)
            end
  
            output.writer.written_text
          end
        end
      end
    end
  end
end
