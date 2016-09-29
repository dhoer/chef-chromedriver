require 'chefspec'
require 'chefspec/berkshelf'

Chef::Config[:chef_gem_compile_time] = false
Chef::Config[:ssl_verify_mode] = :verify_none

ChefSpec::Coverage.start!
