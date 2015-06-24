unless system('bundle exec rake db:create')
  raise "`bundle exec rake db:create` exited #{$?.exitstatus}"
end
