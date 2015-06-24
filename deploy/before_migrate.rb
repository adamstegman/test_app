unless system('rake db:create')
  raise "`rake db:create` exited #{$?.exitstatus}"
end
