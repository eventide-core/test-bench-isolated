module TestBenchIsolated
  module TestBench
    class Run
      module Controls
        module File
          module Create
            def self.call(contents: nil, directory: nil)
              contents ||= self.contents
              directory ||= self.directory
  
              filename = File::Name::Random.example
  
              file = ::File.join(directory, filename)
  
              ::File.write(file, contents)
  
              file
            end
  
            def self.contents
              '# Some file'
            end
  
            def self.directory
              'tmp'
            end
  
            module Pass
              def self.call(directory: nil)
                Create.(contents:, directory:)
              end
  
              def self.contents
                Create.contents
              end
            end
  
            module Failure
              def self.call(session: nil, directory: nil)
                contents = contents(session:)
  
                Create.(contents:, directory:)
              end
  
              def self.contents(session: nil)
                session ||= Session.new
  
                <<~RUBY
                session = ObjectSpace._id2ref(#{session.object_id})
                session.test do
                  session.assert(false)
                end
                RUBY
              end
            end
  
            module Crash
              def self.call(directory: nil)
                Create.(contents:, directory:)
              end
  
              def self.contents
                "raise #{Exception}.example"
              end
            end
          end
        end
      end
    end
  end
end
