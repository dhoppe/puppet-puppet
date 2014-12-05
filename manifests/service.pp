# == Class: puppet::service
#
class puppet::service {
  if $::puppet::service_name {
    service { 'puppet':
      ensure     => $::puppet::_service_ensure,
      name       => $::puppet::service_name,
      enable     => $::puppet::_service_enable,
      hasrestart => true,
    }
  }
}
