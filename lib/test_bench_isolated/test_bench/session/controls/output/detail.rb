module TestBenchIsolated
  module TestBench
    class Session
      module Controls
        module Output
          module Detail
            def self.example
              Session::Output::Detail.on
            end
  
            def self.other_example
              Session::Output::Detail.off
            end
  
            def self.random
              details = [
                Session::Output::Detail.on,
                Session::Output::Detail.off,
                Session::Output::Detail.failure
              ]
  
              index = Random.integer % details.count
  
              details[index]
            end
          end
        end
      end
    end
  end
end
