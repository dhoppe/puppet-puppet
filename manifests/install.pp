# == Class: puppet::install
#
class puppet::install {
  if $::puppet::package_name {
    package { 'puppet':
      ensure => $::puppet::package_ensure,
      name   => $::puppet::package_name,
    }
  }

  if $::puppet::package_list {
    ensure_resource('package', $::puppet::package_list, { 'ensure' => $::puppet::package_ensure })
  }
}
