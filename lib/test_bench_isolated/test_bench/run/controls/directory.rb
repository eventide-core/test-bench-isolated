module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module Directory
          def self.example(name=nil, parent_directory: nil, root_directory: nil)
            name ||= self.name
            parent_directory ||= self.parent_directory
  
            ::File.join(parent_directory, name)
          end
  
          def self.random
            Random.example
          end
  
          def self.name
            Name.example
          end
  
          def self.parent_directory
            File::Create.directory
          end
  
          def self.root_directory
            File::Create.root_directory
          end
  
          module Pattern
            def self.example
              'some-directory*'
            end
          end
  
          module Random
            def self.example(basename: nil, parent_directory: nil)
              name = Name::Random.example(basename)
  
              Directory.example(name, parent_directory:)
            end
          end
  
          module Name
            def self.example
              "some-directory"
            end
  
            module Random
              def self.example(basename=nil)
                basename ||= Name.example
  
                suffix = Controls::Random.string
  
                "#{basename}-#{suffix}"
              end
            end
          end
  
          module Create
            def self.call(basename: nil, parent_directory: nil)
              directory = Random.example(basename:, parent_directory:)
  
              ::Dir.mkdir(directory)
  
              directory
            end
          end
        end
      end
    end
  end
end
