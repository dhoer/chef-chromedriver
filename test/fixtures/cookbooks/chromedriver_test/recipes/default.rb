# Chrome not supported on rhel < 7
unless platform_family?('rhel') && node['platform_version'].split('.')[0] <= '6'
  include_recipe 'java_se'
  include_recipe 'selenium::hub'
  include_recipe 'xvfb' unless platform?('windows', 'mac_os_x')
  include_recipe 'chrome'
  include_recipe 'chromedriver'

  node.set['selenium']['node']['capabilities'] = [
    {
      browserName: 'chrome',
      maxInstances: 5,
      version: chrome_version,
      seleniumProtocol: 'WebDriver'
    }
  ]

  include_recipe 'selenium::node'
end
