# == Class: puppet::config
#
class puppet::config {
  if $::puppet::config_dir_source {
    file { 'puppet.dir':
      ensure  => $::puppet::config_dir_ensure,
      path    => $::puppet::config_dir_path,
      force   => $::puppet::config_dir_purge,
      purge   => $::puppet::config_dir_purge,
      recurse => $::puppet::config_dir_recurse,
      source  => $::puppet::config_dir_source,
      notify  => $::puppet::config_file_notify,
      require => $::puppet::config_file_require,
    }
  }

  if $::puppet::config_file_path and $::puppet::server_mode == undef {
    file { 'puppet.conf':
      ensure  => $::puppet::config_file_ensure,
      path    => $::puppet::config_file_path,
      owner   => $::puppet::config_file_owner,
      group   => $::puppet::config_file_group,
      mode    => $::puppet::config_file_mode,
      source  => $::puppet::config_file_source,
      content => $::puppet::config_file_content,
      notify  => $::puppet::config_file_notify,
      require => $::puppet::config_file_require,
    }
  }
}
