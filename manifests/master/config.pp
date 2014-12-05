# == Class: puppet::master::config
#
class puppet::master::config {
  file { 'hiera.dir':
    ensure  => $::puppet::config_dir_ensure,
    path    => "${::puppet::config_dir_path}/hieradata",
    force   => $::puppet::config_dir_purge,
    purge   => $::puppet::config_dir_purge,
    recurse => $::puppet::config_dir_recurse,
    source  => $::puppet::config_dir_source,
    notify  => $::puppet::master::config_file_notify,
    require => $::puppet::master::config_file_require,
  }

  file { 'hiera.conf':
    ensure => 'link',
    path   => '/etc/hiera.yaml',
    force  => true,
    target => "${::puppet::config_dir_path}/hiera.yaml",
  }

  file { 'puppet.conf':
    ensure  => $::puppet::config_file_ensure,
    path    => $::puppet::config_file_path,
    owner   => $::puppet::config_file_owner,
    group   => $::puppet::config_file_group,
    mode    => $::puppet::config_file_mode,
    source  => $::puppet::config_file_source,
    content => $::puppet::config_file_content,
    notify  => $::puppet::master::config_file_notify,
    require => $::puppet::master::config_file_require,
  }

  tidy { 'bucket':
    path    => '/var/lib/puppet/bucket',
    age     => '4w',
    recurse => true,
  }

  tidy { 'clientbucket':
    path    => '/var/lib/puppet/clientbucket',
    age     => '4w',
    recurse => true,
  }

  tidy { 'reports':
    path    => '/var/lib/puppet/reports',
    age     => '4w',
    recurse => true,
  }
}
