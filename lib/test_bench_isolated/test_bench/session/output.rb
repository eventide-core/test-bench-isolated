module TestBenchIsolated
  module TestBench
    class Session
      class Output
        include TestBench::Output
        include Events
  
        def pending_writer
          @pending_writer ||= Writer::Substitute.build
        end
        attr_writer :pending_writer
  
        def passing_writer
          @passing_writer ||= Writer::Substitute.build
        end
        attr_writer :passing_writer
  
        def failing_writer
          @failing_writer ||= Writer::Substitute.build
        end
        attr_writer :failing_writer
  
        def failures
          @failures ||= 0
        end
        attr_writer :failures
  
        def mode
          @mode ||= Mode.initial
        end
        attr_writer :mode
  
        def branch_count
          @branch_count ||= 0
        end
        attr_writer :branch_count
  
        def detail_policy
          @detail_policy ||= Detail.default
        end
        alias :detail :detail_policy
        attr_writer :detail_policy
  
        def configure(detail: nil, **arguments)
          if not detail.nil?
            self.detail_policy = detail
          end
  
          Writer.configure(self, **arguments, attr_name: :pending_writer)
        end
  
        def receive(event_data)
          case event_data.type
          when ContextStarted.event_type, TestStarted.event_type
            branch
          end
  
          if initial?
            handle(event_data)
  
          else
            self.mode = Mode.failing
            handle(event_data)
  
            self.mode = Mode.passing
            handle(event_data)
  
            self.mode = Mode.pending
            handle(event_data)
          end
  
          case event_data.type
          when ContextFinished.event_type, TestFinished.event_type
            _title, result = event_data.data
            merge(result)
          end
        end
  
        handle ContextStarted do |context_started|
          title = context_started.title
  
          if not title.nil?
            writer.
              indent.
              style(:green).
              puts(title)
  
            writer.indent!
  
            if branch_count == 1
              self.failures = 0
            end
          end
        end
  
        handle ContextFinished do |context_finished|
          title = context_finished.title
  
          if not title.nil?
            writer.deindent!
  
            if branch_count == 1
              writer.puts
  
              if failing? && failures > 0
                writer.
                  style(:bold, :red).
                  puts("Failure#{'s' if not failures == 1}: #{failures}")
  
                writer.puts
              end
            end
          end
        end
  
        handle ContextSkipped do |context_skipped|
          title = context_skipped.title
  
          if not writer.styling?
            title = "#{title} (skipped)"
          end
  
          writer.
            indent.
            style(:yellow).
            puts(title)
        end
  
        handle TestStarted do |test_started|
          title = test_started.title
  
          if title.nil?
            if passing?
              return
            else
              title = 'Test'
            end
          end
  
          writer.indent
  
          if passing?
            writer.style(:green)
          elsif failing?
            if not writer.styling?
              title = "#{title} (failed)"
            end
  
            writer.style(:bold, :red)
          elsif pending?
            writer.style(:faint)
          end
  
          writer.puts(title)
  
          writer.indent!
        end
  
        handle TestFinished do |test_finished|
          title = test_finished.title
  
          if passing? && title.nil?
            return
          end
  
          writer.deindent!
        end
  
        handle TestSkipped do |test_skipped|
          title = test_skipped.title
  
          if not writer.styling?
            title = "#{title} (skipped)"
          end
  
          writer.
            indent.
            style(:yellow).
            puts(title)
        end
  
        handle Failed do |failed|
          message = failed.message
  
          if failing?
            self.failures += 1
          end
  
          writer
            .indent
            .style(:red)
            .puts(message)
        end
  
        handle Detailed do |detailed|
          if not detail?
            return
          end
  
          text = detailed.text
          quote = detailed.quote
          heading = detailed.heading
  
          comment(text, quote, heading)
        end
  
        handle Commented do |commented|
          text = commented.text
          quote = commented.quote
          heading = commented.heading
  
          comment(text, quote, heading)
        end
  
        def comment(text, quote, heading)
          if not heading.nil?
            writer.
              indent.
              style(:bold, :underline).
              puts(heading)
  
            if not writer.styling?
              writer.
                indent.
                puts('- - -')
            end
          end
  
          if text.empty?
            writer.
              indent.
              style(:faint, :italic).
              puts('(empty)')
            return
          end
  
          if not quote
            writer.
              indent.
              puts(text)
          else
            text.each_line(chomp: true) do |line|
              writer.
                indent.
                style(:faint).
                print('> ').
                style(:reset_intensity).
                puts(line)
            end
          end
        end
  
        def current_writer
          if initial? || pending?
            pending_writer
          elsif passing?
            passing_writer
          elsif failing?
            failing_writer
          end
        end
        alias :writer :current_writer
  
        def branch
          if branch_count.zero?
            self.mode = Mode.pending
  
            pending_writer.sync = false
  
            parent_writer = pending_writer
          else
            parent_writer = passing_writer
          end
  
          self.branch_count += 1
  
          self.passing_writer, self.failing_writer = parent_writer.branch
        end
  
        def merge(result)
          self.branch_count -= 1
  
          if not branched?
            pending_writer.sync = true
  
            self.mode = Mode.initial
          end
  
          if result
            writer = passing_writer
          else
            writer = failing_writer
          end
  
          writer.flush
  
          self.passing_writer = writer.device
          self.failing_writer = writer.alternate_device
        end
  
        def branched?
          branch_count > 0
        end
  
        def initial?
          mode == Mode.initial
        end
  
        def pending?
          mode == Mode.pending
        end
  
        def passing?
          mode == Mode.passing
        end
  
        def failing?
          mode == Mode.failing
        end
  
        def detail?
          Detail.detail?(detail_policy, mode)
        end
  
        module Mode
          def self.initial = :initial
          def self.pending = :pending
          def self.passing = :passing
          def self.failing = :failing
        end
  
        module Detail
          Error = Class.new(RuntimeError)
  
          def self.detail?(policy, mode)
            assure_detail(policy, mode)
          end
  
          def self.assure_detail(policy, mode=nil)
            mode ||= Mode.initial
  
            case policy
            when on
              true
            when off
              false
            when failure
              if mode == Mode.failing || mode == Mode.initial
                true
              else
                false
              end
            else
              raise Error, "Unknown detail policy #{policy.inspect}"
            end
          end
  
          def self.on = :on
          def self.off = :off
          def self.failure = :failure
  
          def self.default
            policy = ENV.fetch('TEST_BENCH_DETAIL') do
              return default!
            end
  
            policy.to_sym
          end
  
          def self.default!
            :failure
          end
        end
      end
    end
  end
end
