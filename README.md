# puppet

[![Build Status](https://travis-ci.org/dhoppe/puppet-puppet.png?branch=master)](https://travis-ci.org/dhoppe/puppet-puppet)
[![Code Coverage](https://coveralls.io/repos/github/dhoppe/puppet-puppet/badge.svg?branch=master)](https://coveralls.io/github/dhoppe/puppet-puppet)
[![Puppet Forge](https://img.shields.io/puppetforge/v/dhoppe/puppet.svg)](https://forge.puppetlabs.com/dhoppe/puppet)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/dhoppe/puppet.svg)](https://forge.puppetlabs.com/dhoppe/puppet)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/dhoppe/puppet.svg)](https://forge.puppetlabs.com/dhoppe/puppet)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/dhoppe/puppet.svg)](https://forge.puppetlabs.com/dhoppe/puppet)

#### Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with puppet](#setup)
    * [What puppet affects](#what-puppet-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet](#beginning-with-puppet)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module installs, configures and manages the Puppet service.

## Module Description

This module handles installing, configuring and running Puppet across a range of
operating systems and distributions.

## Setup

### What puppet affects

* puppet package.
* puppet configuration file.
* puppet service.

### Setup Requirements

* Puppet >= 3.0
* Facter >= 1.6
* [Extlib module](https://github.com/voxpupuli/puppet-extlib)
* [Stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)

### Beginning with puppet

Install puppet with the default parameters ***(No configuration files will be changed)***.

```puppet
    class { 'puppet': }
```

Install puppet with the recommended parameters.

#### Client/Server setup (client)

```puppet
    class { 'puppet':
      config_file_template => 'puppet/common/etc/puppet/puppet.conf.erb',
      config_file_hash     => {
        'puppet' => {
          config_file_path     => '/etc/default/puppet',
          config_file_template => 'puppet/common/etc/default/puppet.erb',
        },
      },
    }
```

#### Client/Server setup (server)

```puppet
    class { 'puppet':
      config_file_template => 'puppet/common/etc/puppet/puppetmaster.conf.erb',
      config_file_hash     => {
        'puppet'          => {
          config_file_path     => '/etc/default/puppet',
          config_file_template => 'puppet/common/etc/default/puppet.erb',
        },
        'puppetmaster'    => {
          config_file_path     => '/etc/default/puppetmaster',
          config_file_template => 'puppet/common/etc/default/puppetmaster.erb',
          config_file_notify   => 'Service[puppetmaster]',
          config_file_require  => 'Package[puppetmaster]',
        },
        'auth.conf'       => {
          config_file_path     => '/etc/puppet/auth.conf',
          config_file_template => 'puppet/common/etc/puppet/auth.conf.erb',
          config_file_notify   => 'Service[puppetmaster]',
          config_file_require  => 'Package[puppetmaster]',
        },
        'hiera.yaml'      => {
          config_file_path    => '/etc/puppet/hiera.yaml',
          config_file_source  => 'puppet:///modules/puppet/common/etc/puppet/hiera.yaml',
          config_file_notify  => 'Service[puppetmaster]',
          config_file_require => 'Package[puppetmaster]',
        },
        'fileserver.conf' => {
          config_file_path     => '/etc/puppet/fileserver.conf',
          config_file_template => 'puppet/common/etc/puppet/fileserver.conf.erb',
          config_file_notify   => 'Service[puppetmaster]',
          config_file_require  => 'Package[puppetmaster]',
        },
      },
      master_storeconfigs  => 'puppetdb',
      server_mode          => 'webrick',
    }
```

## Usage

Update the puppet package.

```puppet
    class { 'puppet':
      package_ensure => 'latest',
    }
```

Remove the puppet package.

```puppet
    class { 'puppet':
      package_ensure => 'absent',
    }
```

Purge the puppet package ***(All configuration files will be removed)***.

```puppet
    class { 'puppet':
      package_ensure => 'purged',
    }
```

Deploy the configuration files from source directory.

```puppet
    class { 'puppet':
      config_dir_source => 'puppet:///modules/puppet/common/etc/puppet',
    }
```

Deploy the configuration files from source directory ***(Unmanaged configuration
files will be removed)***.

```puppet
    class { 'puppet':
      config_dir_purge  => true,
      config_dir_source => 'puppet:///modules/puppet/common/etc/puppet',
    }
```

Deploy the configuration file from source.

```puppet
    class { 'puppet':
      config_file_source => 'puppet:///modules/puppet/common/etc/puppet/puppet.conf',
    }
```

Deploy the configuration file from string.

```puppet
    class { 'puppet':
      config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
    }
```

Deploy the configuration file from template.

```puppet
    class { 'puppet':
      config_file_template => 'puppet/common/etc/puppet/puppet.conf.erb',
    }
```

Deploy the configuration file from custom template ***(Additional parameters can
be defined)***.

```puppet
    class { 'puppet':
      config_file_template     => 'puppet/common/etc/puppet/puppet.conf.erb',
      config_file_options_hash => {
        'key' => 'value',
      },
    }
```

Deploy additional configuration files from source, string or template.

```puppet
    class { 'puppet':
      config_file_hash => {
        'puppet.2nd.conf' => {
          config_file_path   => '/etc/puppet/puppet.2nd.conf',
          config_file_source => 'puppet:///modules/puppet/common/etc/puppet/puppet.2nd.conf',
        },
        'puppet.3rd.conf' => {
          config_file_path   => '/etc/puppet/puppet.3rd.conf',
          config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        },
        'puppet.4th.conf' => {
          config_file_path     => '/etc/puppet/puppet.4th.conf',
          config_file_template => 'puppet/common/etc/puppet/puppet.4th.conf.erb',
        },
      },
    }
```

Disable the puppet service.

```puppet
    class { 'puppet':
      service_ensure => 'stopped',
    }
```

## Reference

### Classes

#### Public Classes

* puppet: Main class, includes all other classes.

#### Private Classes

* puppet::install: Handles the packages.
* puppet::config: Handles the configuration file.
* puppet::service: Handles the service.

### Parameters

#### `package_ensure`

Determines if the package should be installed. Valid values are 'present',
'latest', 'absent' and 'purged'. Defaults to 'present'.

#### `package_name`

Determines the name of package to manage. Defaults to 'puppet'.

#### `package_list`

Determines if additional packages should be managed. Defaults to 'undef'.

#### `config_dir_ensure`

Determines if the configuration directory should be present. Valid values are
'absent' and 'directory'. Defaults to 'directory'.

#### `config_dir_path`

Determines if the configuration directory should be managed. Defaults to '/etc/puppet'

#### `config_dir_purge`

Determines if unmanaged configuration files should be removed. Valid values are
'true' and 'false'. Defaults to 'false'.

#### `config_dir_recurse`

Determines if the configuration directory should be recursively managed. Valid
values are 'true' and 'false'. Defaults to 'true'.

#### `config_dir_source`

Determines the source of a configuration directory. Defaults to 'undef'.

#### `config_file_ensure`

Determines if the configuration file should be present. Valid values are 'absent'
and 'present'. Defaults to 'present'.

#### `config_file_path`

Determines if the configuration file should be managed. Defaults to '/etc/puppet/puppet.conf'

#### `config_file_owner`

Determines which user should own the configuration file. Defaults to 'root'.

#### `config_file_group`

Determines which group should own the configuration file. Defaults to 'root'.

#### `config_file_mode`

Determines the desired permissions mode of the configuration file. Defaults to '0644'.

#### `config_file_source`

Determines the source of a configuration file. Defaults to 'undef'.

#### `config_file_string`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_template`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_notify`

Determines if the service should be restarted after configuration changes.
Defaults to 'Service[puppet]'.

#### `config_file_require`

Determines which package a configuration file depends on. Defaults to 'Package[puppet]'.

#### `config_file_hash`

Determines which configuration files should be managed via `puppet::define`.
Defaults to '{}'.

#### `config_file_options_hash`

Determines which parameters should be passed to an ERB template. Defaults to '{}'.

#### `service_ensure`

Determines if the service should be running or not. Valid values are 'running'
and 'stopped'. Defaults to 'running'.

#### `service_name`

Determines the name of service to manage. Defaults to 'puppet'.

#### `service_enable`

Determines if the service should be enabled at boot. Valid values are 'true'
and 'false'. Defaults to 'true'.

#### `main_etckeeper`

Determines if the etckeeper hooks should be enabled. Valid values are 'true'
and 'false'. Defaults to 'false'.

#### `agent_environment`

Determines which environment should be used. Defaults to 'production'.

#### `agent_listen`

Determines if puppet agent should listen for connections. Valid values are 'true'
and 'false'. Defaults to 'false'.

#### `agent_pluginsync`

Determines if pluginsync should be enabled. Valid values are 'true' and 'false'.
Defaults to 'true'.

#### `agent_puppetdlog`

Determines if puppet agent should write a log to '/var/log/puppet/puppet.log'.
Valid values are 'true' and 'false'. Defaults to 'true'.

#### `agent_report`

Determines if puppet agent should send reports after every transaction. Valid
values are 'true' and 'false'. Defaults to 'true'.

#### `agent_server`

Determines which puppet master should be used. Defaults to "puppet.${::domain}".

#### `master_autosign`

Determines if puppet master should autosign any key request. Defaults to 'false'.

#### `master_environmentpath`

Determines environmentpath to enable directory environments. Defaults to '$confdir/environments'.

#### `master_puppetdlog`

Determines if puppet master should write a log to
'/var/log/puppet/puppetmaster.log'. Valid values are 'true' and 'false'. Defaults
to 'true'.

#### `master_reports`

Determines wich kind of reports puppet master should generate. Valid values are
'http', 'log', 'rrdgraph', 'store' and 'tagmail'. Defaults to '['store']'.

#### `master_storeconfigs`

Determines if the catalog, facts and related data of each client should be stored.
This also enables the import and export of resources. Valid values are 'puppetdb'.
Defaults to 'undef'.

***This module does not install and manage PuppetDB***.

Please use this [PuppetDB module](https://github.com/puppetlabs/puppetlabs-puppetdb)
and the following code for that purpose.

```puppet
    class { 'puppetdb': }
    class { 'puppetdb::master::config':
      manage_storeconfigs => false,
    }
```

#### `master_strict_variables`

Determines if the parser should raise errors when referencing unknown variables.
Valid values are 'true' and 'false'. Defaults to 'false'.

#### `master_stringify_facts`

Determines if fact values should be flatten to string. Valid values are 'true'
and 'false'. Defaults to 'true'.

#### `server_mode`

Determines if puppet master should be installed and how HTTPS requests are served.
Valid values are 'webrick'. Defaults to 'undef'.

## Limitations

This module has been tested on:

* Debian 6/7/8
* Ubuntu 12.04/14.04

## Development

### Bug Report

If you find a bug, have trouble following the documentation or have a question
about this module - please create an issue.

### Pull Request

If you are able to patch the bug or add the feature yourself - please make a
pull request.

### Contributors

The list of contributors can be found at: [https://github.com/dhoppe/puppet-puppet/graphs/contributors](https://github.com/dhoppe/puppet-puppet/graphs/contributors)
