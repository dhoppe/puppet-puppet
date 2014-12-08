# == Class: puppet
#
class puppet (
  $package_ensure           = 'present',
  $package_name             = $::puppet::params::package_name,
  $package_list             = $::puppet::params::package_list,

  $config_dir_path          = $::puppet::params::config_dir_path,
  $config_dir_purge         = false,
  $config_dir_recurse       = true,
  $config_dir_source        = undef,

  $config_file_path         = $::puppet::params::config_file_path,
  $config_file_owner        = $::puppet::params::config_file_owner,
  $config_file_group        = $::puppet::params::config_file_group,
  $config_file_mode         = $::puppet::params::config_file_mode,
  $config_file_source       = undef,
  $config_file_string       = undef,
  $config_file_template     = undef,

  $config_file_notify       = $::puppet::params::config_file_notify,
  $config_file_require      = $::puppet::params::config_file_require,

  $config_file_hash         = {},
  $config_file_options_hash = {},

  $service_ensure           = 'running',
  $service_name             = $::puppet::params::service_name,
  $service_enable           = true,

  $main_etckeeper           = false,

  $agent_environment        = 'production',
  $agent_listen             = false,
  $agent_pluginsync         = true,
  $agent_puppetdlog         = true,
  $agent_report             = true,
  $agent_server             = "puppet.${::domain}",

  $master_autosign          = false,
  $master_puppetdlog        = true,
  $master_reports           = ['store'],
  $master_storeconfigs      = undef,
  $master_strict_variables  = false,
  $master_stringify_facts   = true,

  $server_mode              = undef,
) inherits ::puppet::params {
  validate_re($package_ensure, '^(absent|latest|present|purged)$')
  validate_string($package_name)
  if $package_list { validate_array($package_list) }

  validate_absolute_path($config_dir_path)
  validate_bool($config_dir_purge)
  validate_bool($config_dir_recurse)
  if $config_dir_source { validate_string($config_dir_source) }

  validate_absolute_path($config_file_path)
  validate_string($config_file_owner)
  validate_string($config_file_group)
  validate_string($config_file_mode)
  if $config_file_source { validate_string($config_file_source) }
  if $config_file_string { validate_string($config_file_string) }
  if $config_file_template { validate_string($config_file_template) }

  validate_string($config_file_notify)
  validate_string($config_file_require)

  validate_hash($config_file_hash)
  validate_hash($config_file_options_hash)

  validate_re($service_ensure, '^(running|stopped)$')
  validate_string($service_name)
  validate_bool($service_enable)

  $config_file_content = default_content($config_file_string, $config_file_template)

  if $config_file_hash {
    create_resources('puppet::define', $config_file_hash)
  }

  if $package_ensure == 'absent' {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } elsif $package_ensure == 'purged' {
    $config_dir_ensure  = 'absent'
    $config_file_ensure = 'absent'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } else {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
    $_service_ensure    = $service_ensure
    $_service_enable    = $service_enable
  }

  validate_re($config_dir_ensure, '^(absent|directory)$')
  validate_re($config_file_ensure, '^(absent|present)$')

  if $server_mode {
    class { '::puppet::master': }
  }

  anchor { 'puppet::begin': } ->
  class { '::puppet::install': } ->
  class { '::puppet::config': } ~>
  class { '::puppet::service': } ->
  anchor { 'puppet::end': }
}
