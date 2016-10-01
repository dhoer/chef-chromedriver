name 'chromedriver_test'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Tests ChromeDriver'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

depends 'chromedriver'
depends 'java_se', '~> 8.0'
depends 'selenium', '~> 3.0'
depends 'xvfb', '~> 2.0'
depends 'chrome', '~> 2.0'
