namespace :resque do
  task :setup do
    require Rails.root.join 'config', 'initializers', 'resque'
  end
end