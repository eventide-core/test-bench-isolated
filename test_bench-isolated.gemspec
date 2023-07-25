# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'test_bench-isolated'
  s.version = '0.0.0.7'

  s.authors = ['Nathan Ladd']
  s.email = 'nathanladd+github@gmail.com'
  s.homepage = 'https://github.com/test-bench/test-bench-isolated'
  s.licenses = %w(MIT)
  s.summary = "Isolated copy of TestBench for testing TestBench"
  s.platform = Gem::Platform::RUBY

  s.bindir = 'script'
  s.executables << 'bench'

  s.require_paths = %w(lib)
  s.files = Dir.glob 'lib/**/*'
end
