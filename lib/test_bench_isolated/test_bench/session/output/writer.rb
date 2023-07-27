module TestBenchIsolated
  module TestBench
    class Session
      class Output
        class Writer < TestBench::Output::Writer
          attr_accessor :peer
  
          def alternate_device
            @alternate_device ||= TestBench::Output::Device::Substitute.build
          end
          attr_writer :alternate_device
  
          def indentation_depth
            @indentation_depth ||= 0
          end
          attr_writer :indentation_depth
  
          def configure
            device = self.device
  
            self.alternate_device = TestBench::Output::Device::Null.build
  
            Buffer.configure(self, device:)
          end
  
          def self.follow(previous_writer)
            device = previous_writer
  
            alternate_device = previous_writer.peer
            alternate_device ||= TestBench::Output::Device::Null.build
  
            previous_digest = previous_writer.digest
            digest = previous_digest.clone
  
            writer = new
            writer.sync = false
            writer.device = device
            writer.alternate_device = alternate_device
            writer.styling_policy = previous_writer.styling_policy
            writer.digest = digest
            writer.sequence = previous_writer.sequence
            writer.column_sequence = previous_writer.column_sequence
            writer.indentation_depth = previous_writer.indentation_depth
            writer.digest = previous_writer.digest.clone
            writer
          end
  
          def branch
            alternate = self.class.follow(self)
            primary = self.class.follow(self)
  
            primary.peer = alternate
  
            return primary, alternate
          end
  
          def indent
            indentation = '  ' * indentation_depth
  
            print(indentation)
          end
  
          def flush
            buffer.flush(device, alternate_device)
          end
  
          def write!(data)
            device.write(data)
            alternate_device.write(data)
          end
  
          def increase_indentation
            self.indentation_depth += 1
          end
          alias :indent! :increase_indentation
  
          def decrease_indentation
            self.indentation_depth -= 1
          end
          alias :deindent! :decrease_indentation
  
          def follows?(other_writer)
            if sequence < other_writer.sequence
              false
            elsif device == other_writer
              true
            elsif device == other_writer.peer
              true
            else
              false
            end
          end
        end
      end
    end
  end
end
