# == Class: puppet::master::service
#
class puppet::master::service {
  service { 'puppetmaster':
    ensure     => $::puppet::master::service_ensure,
    name       => $::puppet::master::service_name,
    enable     => $::puppet::master::service_enable,
    hasrestart => true,
  }
}
