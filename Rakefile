begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "-c -w"
    t.verbose = false
  end
  task default: :spec
rescue LoadError
  # rspec not available
end