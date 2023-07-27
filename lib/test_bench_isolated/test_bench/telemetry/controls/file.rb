module TestBenchIsolated
  module TestBench
    class Telemetry
      module Controls
        module File
          def self.example(...)
            Temporary.example(...)
          end
  
          def self.random
            Random.example
          end
  
          module Random
            def self.example(...)
              Temporary::Random.example(...)
            end
          end
  
          module Name
            def self.example(basename: nil, extension: nil)
              basename ||= self.basename
              extension ||= self.extension
  
              "#{basename}#{extension}"
            end
  
            def self.random
              Random.example
            end
  
            def self.basename
              'some-file'
            end
  
            def self.extension
              '.some-ext'
            end
  
            module Random
              def self.example(basename: nil, extension: nil)
                extension ||= self.extension
  
                basename = Basename.example(basename:)
  
                Name.example(basename:, extension:)
              end
  
              def self.extension
                suffix = Controls::Random.string[0..4]
  
                "#{Name.extension}-#{suffix}"
              end
  
              module Basename
                def self.example(basename: nil)
                  basename ||= Name.basename
  
                  suffix = Controls::Random.string
  
                  "#{basename}-#{suffix}"
                end
              end
            end
          end
  
          module Temporary
            def self.example(...)
              filename = Name.example(...)
  
              ::File.join('tmp', filename)
            end
  
            module Random
              def self.example(...)
                filename = Name::Random.example(...)
  
                ::File.join('tmp', filename)
              end
            end
          end
        end
      end
    end
  end
end
