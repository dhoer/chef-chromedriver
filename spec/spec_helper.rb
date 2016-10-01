require 'chefspec'
require 'chefspec/berkshelf'

Chef::Config[:chef_gem_compile_time] = false
Chef::Config[:ssl_verify_mode] = :verify_none

CACHE = Chef::Config[:file_cache_path]
VERSION = '2.24'.freeze

ChefSpec::Coverage.start!
