# Selenium ChromeDriver Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/chromedriver.svg?style=flat-square)][supermarket]
[![Build Status](http://img.shields.io/travis/dhoer/chef-chromedriver.svg?style=flat-square)][travis]
[![GitHub Issues](http://img.shields.io/github/issues/dhoer/chef-chromedriver.svg?style=flat-square)][github]

[supermarket]: https://supermarket.chef.io/cookbooks/chromedriver
[travis]: https://travis-ci.org/dhoer/chef-chromedriver
[github]: https://github.com/dhoer/chef-chromedriver/issues

Installs ChromeDriver (https://github.com/SeleniumHQ/selenium/wiki/ChromeDriver).

## Requirements

- Chrome (this cookbook does not install Chrome)
- Chef 12.3+

### Platforms

- CentOS, RedHat
- Mac OS X
- Ubuntu
- Windows

### Cookbooks

- windows - Required for Windows when PowerShell 3 or greater is not installed

## Usage

Include recipe in a run list or cookbook to install ChromeDriver.

### Attributes

- `node['chromedriver']['node']['host']` - Defaults to 'ip'
- `node['chromedriver']['node']['port']` - Defaults to 5555
- `node['chromedriver']['node']['jvm_args']` - Defaults to nil

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chromedriver).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-chromedriver/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-chromedriver/graphs/contributors).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-chromedriver/blob/master/LICENSE.md) file for 
details.
