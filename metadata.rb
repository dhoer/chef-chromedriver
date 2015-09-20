name 'chromedriver'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Selenium WebDriver for Chrome'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

supports 'centos'
supports 'redhat'
supports 'mac_os_x'
supports 'ubuntu'
supports 'windows'

depends 'windows', '~> 1.0'

source_url 'https://github.com/dhoer/chef-chromedriver' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-chromedriver/issues' if respond_to?(:issues_url)
