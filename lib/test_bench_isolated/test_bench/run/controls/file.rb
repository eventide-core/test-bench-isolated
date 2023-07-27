module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module File
          def self.example(filename: nil, directory: nil, root_directory: nil)
            filename ||= self.filename
            directory ||= self.directory
  
            if root_directory == :none
              root_directory = nil
            else
              root_directory ||= self.root_directory
            end
  
            paths = []
  
            if root_directory
              paths << root_directory
            end
  
            paths << directory
            paths << filename
  
            ::File.join(*paths)
          end
  
          def self.random
            Test.random
          end
  
          def self.filename
            Name.example
          end
  
          def self.directory
            Test.directory
          end
  
          def self.root_directory
            '/some-root-dir'
          end
  
          module Random
            def self.example(basename: nil, directory: nil, root_directory: nil)
              basename ||= Test::Random.basename
              directory ||= Test::Random.directory
  
              filename = Name::Random.example(basename:)
  
              File.example(filename:, directory:, root_directory:)
            end
          end
  
          module Local
            def self.example
              File.example(root_directory: :none)
            end
  
            def self.random
              File::Random.example(root_directory: :none)
            end
          end
  
          module Test
            extend self
  
            def self.example(root_directory: nil)
              filename = Name.example(basename:)
  
              File.example(filename:, directory:, root_directory:)
            end
  
            def self.random
              Random.example
            end
  
            def basename
              'some_test_file'
            end
  
            def directory
              'test/automated'
            end
  
            module Random
              extend Test
  
              def self.example(root_directory: nil)
                filename = Name::Random.example(basename:)
  
                File.example(filename:, directory:, root_directory:)
              end
            end
  
            module Local
              def self.example
                Test.example(root_directory: :none)
              end
  
              def self.random
                Test::Random.example(root_directory: :none)
              end
            end
          end
  
          module Implementation
            extend self
  
            def self.example(root_directory: nil)
              filename = Name.example(basename:)
  
              File.example(filename:, directory:, root_directory:)
            end
  
            def self.random
              Random.example
            end
  
            def basename
              'some_file'
            end
  
            def directory
              'lib/some_directory'
            end
  
            module Random
              extend Implementation
  
              def self.example(root_directory:  nil)
                filename = Name::Random.example(basename:)
  
                File.example(filename:, directory:, root_directory:)
              end
            end
  
            module Local
              def self.example
                Implementation.example(root_directory: :none)
              end
  
              def self.random
                Implementation::Random.example(root_directory: :none)
              end
            end
          end
  
          module Name
            def self.example(basename: nil)
              basename ||= self.basename
  
              Telemetry::Controls::File::Name.example(basename:, extension:)
            end
  
            def self.random
              Random.example
            end
  
            def self.basename
              'some_file'
            end
  
            def self.extension
              '.rb'
            end
  
            module Random
              def self.example(basename: nil)
                basename ||= Name.basename
  
                extension = Name.extension
  
                Telemetry::Controls::File::Name::Random.example(basename:, extension:)
              end
            end
          end
        end
      end
    end
  end
end
