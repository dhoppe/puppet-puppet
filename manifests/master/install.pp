# == Class: puppet::master::install
#
class puppet::master::install {
  package { 'puppetmaster':
    ensure => $::puppet::package_ensure,
    name   => $::puppet::master::package_name,
  }
}
