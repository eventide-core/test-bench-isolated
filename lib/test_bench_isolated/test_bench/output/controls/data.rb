module TestBenchIsolated
  module TestBench
    module Output
      module Controls
        module Data
          def self.example
            "some-data"
          end
  
          def self.random
            suffix = Random.string
  
            "#{example}-#{suffix}"
          end
  
          module Digest
            def self.example
              '0123456789:;<=>'
            end
  
            def self.digest
              0x3031323334353637 + 0x0038393A3B3C3D3E
            end
  
            module Equivalent
              module SameLength
                def self.example
                  '0123456789:;<=>'
                end
  
                def self.digest
                  Digest.digest
                end
              end
  
              module DifferentLength
                def self.example
                  [Digest.digest].pack('Q>')
                end
  
                def self.digest
                  Digest.digest
                end
              end
            end
          end
        end
      end
    end
  end
end
