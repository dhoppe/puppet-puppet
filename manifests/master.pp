# == Class: puppet::master
#
class puppet::master (
  $package_name        = 'puppetmaster',

  $config_file_notify  = [
    Service[puppet],
    Service[puppetmaster],
  ],
  $config_file_require = [
    Package[puppet],
    Package[puppetmaster],
  ],

  $service_name        = 'puppetmaster',
) {
  if $::puppet::server_mode == 'webrick' {
    $service_ensure = 'running'
    $service_enable = true
  } else {
    $service_ensure = 'stopped'
    $service_enable = false
  }

  anchor { 'puppet::master::begin': } ->
  class { '::puppet::master::install': } ->
  class { '::puppet::master::config': } ~>
  class { '::puppet::master::service': } ->
  anchor { 'puppet::master::end': }
}
