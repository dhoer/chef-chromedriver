# Installs packages required by selenium-webdriver gem for rspec testing
case node[:platform_family]
when 'debian'
  package 'gcc'
  package 'libffi-dev'
when 'rhel'
  include_recipe 'yum'
  package 'gcc'
  package 'libffi-devel'
end

# Chrome install runs at compile time
execute 'sudo apt-get update' do
  action :nothing
  only_if { platform_family?('debian') }
end.run_action(:run)
