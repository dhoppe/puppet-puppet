# == Class: puppet::params
#
class puppet::params {
  $package_name = $::osfamily ? {
    default => 'puppet',
  }

  $package_list = $::osfamily ? {
    default => undef,
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/puppet',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/puppet/puppet.conf',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_notify = $::osfamily ? {
    default => 'Service[puppet]',
  }

  $config_file_require = $::osfamily ? {
    default => 'Package[puppet]',
  }

  $service_name = $::osfamily ? {
    default => 'puppet',
  }

  case $::osfamily {
    'Debian': {
    }
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }
}
