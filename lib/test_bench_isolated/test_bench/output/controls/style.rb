module TestBenchIsolated
  module TestBench
    module Output
      module Controls
        module Style
          def self.example
            :bold
          end
  
          def self.other_example
            :italic
          end
  
          module Unknown
            def self.example
              :unknown
            end
          end
  
          module Code
            def self.example
              '1'
            end
  
            def self.other_example
              '3'
            end
          end
        end
      end
    end
  end
end
