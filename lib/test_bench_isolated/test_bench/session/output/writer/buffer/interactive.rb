module TestBenchIsolated
  module TestBench
    class Session
      class Output
        class Writer
          module Buffer
            class Interactive
              attr_accessor :viewport
  
              attr_accessor :raw_stderr
  
              attr_accessor :stderr_pipe
  
              def stderr_buffer
                @stderr_buffer ||= String.new
              end
  
              def device
                @device ||= TestBench::Output::Device::Substitute.build
              end
              attr_writer :device
  
              attr_accessor :buffering
              def buffering? = !!buffering
  
              def self.build(device=nil)
                device ||= Defaults.device
  
                instance = new
                instance.device = device
                instance
              end
  
              def self.configure(receiver, device: nil, attr_name: nil)
                attr_name ||= :buffer
  
                instance = build(device)
                receiver.public_send(:"#{attr_name}=", instance)
              end
  
              def receive(text)
                if not cursor_saved?
                  save_cursor
                end
  
                bytes_written = viewport.write(text)
  
                write_text = text.byteslice(0, bytes_written)
                device.write(write_text)
  
                if not viewport.capacity?
                  if not buffering?
                    buffering_message = "Output is buffering"
  
                    device.write("\e[0G\e[2m#{buffering_message}\e[22m")
  
                    self.buffering = true
                  end
                end
  
                update_stderr_buffer
  
                bytes_written
              end
  
              def flush(*_devices)
                if cursor_saved?
                  update_stderr_buffer
                  restore_cursor
                end
              end
  
              def save_cursor
                self.viewport = Viewport.get
  
                self.raw_stderr = STDERR.dup
  
                reader, writer = IO.pipe
  
                new_stderr = writer
                STDERR.reopen(new_stderr)
  
                stderr_buffer.clear
  
                self.stderr_pipe = reader
  
                device.write("\e[s")
              end
  
              def restore_cursor
                stderr_pipe.close
  
                device.write("\e[u")
  
                rows_scrolled = viewport.rows_scrolled
  
                if not rows_scrolled.zero?
                  upward_movements = rows_scrolled
                  device.write("\e[#{upward_movements}F")
                end
  
                stderr_buffer.each_line do |line|
                  raw_stderr.write("\e[0K")
                  raw_stderr.write(line)
                end
  
                STDERR.reopen(raw_stderr)
                self.raw_stderr = nil
  
                self.viewport = nil
              end
  
              def update_stderr_buffer
                loop do
                  stderr_text = stderr_pipe.read_nonblock(4096, exception: false)
  
                  if stderr_text == :wait_readable
                    break
                  end
  
                  viewport.write(stderr_text)
  
                  if not buffering?
                    raw_stderr.write(stderr_text)
                  end
  
                  self.stderr_buffer << stderr_text
                end
              end
  
              def viewport?
                !viewport.nil?
              end
              alias :cursor_saved? :viewport?
            end
          end
        end
      end
    end
  end
end
