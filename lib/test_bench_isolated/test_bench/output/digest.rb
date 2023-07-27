module TestBenchIsolated
  module TestBench
    module Output
      class Digest
        def last_digest
          @last_digest ||= 0
        end
        attr_writer :last_digest
  
        def buffer
          @buffer ||= String.new(encoding: 'BINARY', capacity: Defaults.size_bytes * 2)
        end
        attr_writer :buffer
  
        def self.digest(data)
          instance = new
          instance.update(data)
          instance.digest
        end
  
        def self.configure(receiver, inert: nil, attr_name: nil)
          attr_name ||= :digest
          inert = true if inert.nil?
  
          if inert
            instance = Null.new
          else
            instance = self.new
          end
  
          receiver.public_send(:"#{attr_name}=", instance)
        end
  
        def clone
          cloned_digest = Digest.new
          cloned_digest.last_digest = last_digest
          cloned_digest.buffer << buffer
          cloned_digest
        end
  
        def update(data)
          digest_size_bytes = Defaults.size_bytes
  
          (0..data.bytesize).step(digest_size_bytes).each do |position|
            next_bytes = data.byteslice(position, digest_size_bytes)
            next_bytes.force_encoding('BINARY')
  
            buffer << next_bytes
  
            if buffer.length >= digest_size_bytes
              self.last_digest = digest
  
              buffer.slice!(0, 8)
            end
          end
  
          digest
        end
  
        def digest
          buffer_bytes = buffer.unpack('C*')[0...8]
  
          buffer_int64 = buffer_bytes.reduce(0) do |int64, byte|
            (int64 << 8) | byte
          end
  
          (last_digest + buffer_int64) % (256 ** Defaults.size_bytes - 1)
        end
        alias :value :digest
        alias :to_i :digest
  
        def digest?(data)
          other_digest = self.class.digest(data)
  
          digest == other_digest
        end
  
        def format
          self.class.format(value)
        end
        alias :to_s :format
  
        def self.format(digest)
          if digest < 0
            # 0x8000...
            sign_mask = 0x1 << (8 * Defaults.size_bytes - 1)
            # 0x7FFF...
            mask = (256 ** Defaults.size_bytes - 1) ^ sign_mask
  
            digest_uint64 = ~digest & mask | sign_mask
          else
            digest_uint64 = digest
          end
  
          "0x%016X" % digest_uint64
        end
  
        class Null
          def update(_data)
          end
  
          def digest?(_data)
            false
          end
        end
  
        module Defaults
          def self.size_bytes
            8
          end
        end
      end
    end
  end
end
