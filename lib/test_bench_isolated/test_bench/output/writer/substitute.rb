module TestBenchIsolated
  module TestBench
    module Output
      class Writer
        module Substitute
          def self.build
            Writer.build
          end
  
          def self.included(cls)
            cls.class_exec do
              extend Build
            end
          end
  
          def written_data
            device.written_data
          end
          alias :written_text :written_data
  
          def styling!
            self.styling_policy = Styling.on
          end
  
          module Build
            def build
              instance = new
              instance.buffer.limit = 0
              instance
            end
          end
  
          class Writer < Writer
            include Substitute
          end
        end
      end
    end
  end
end
