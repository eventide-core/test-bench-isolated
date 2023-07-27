module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module File
          module Pattern
            def self.example
              File.example
            end
  
            def self.other_example
              '*.rb'
            end
  
            module File
              def self.example
                'some_file*.rb'
              end
            end
  
            module None
              def self.example
                random
              end
  
              def self.random
                Controls::Random.string
              end
            end
          end
        end
      end
    end
  end
end
