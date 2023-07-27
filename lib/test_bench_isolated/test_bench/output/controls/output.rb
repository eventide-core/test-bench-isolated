module TestBenchIsolated
  module TestBench
    module Output
      module Controls
        module Output
          def self.example_class(&block)
            Class.new do
              include TestBench::Output
  
              class_exec(&block)
            end
          end
  
          class Example
            include TestBench::Output
          end
  
          module Configure
            class Example
              include TestBench::Output
              attr_accessor :some_attr
  
              def configure(some_attr: nil, **arguments)
                self.some_attr = some_attr
              end
  
              def configured?(some_attr)
                self.some_attr == some_attr
              end
            end
          end
        end
      end
    end
  end
end
