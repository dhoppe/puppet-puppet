class puppet::master inherits puppet {
  Puppet::Config['/etc/puppet/puppet.conf'] {
    config    => 'master',
    dbadapter => $dbadapter,
    dbpasswd  => $dbpasswd,
    dbserver  => $dbserver,
    notify    +> Service['puppetmaster'],
    require   +> $puppet::params::package,
  }

  if $dbadapter == 'mysql' {
    package { 'libmysql-ruby':
      ensure => present,
    }
  } elsif $dbadapter == 'postgresql' {
    package { 'pg':
      ensure   => present,
      provider => gem,
    }
  }

  package { [
    'hiera',
    'hiera-puppet' ]:
    ensure   => present,
    provider => gem,
  }

  package { [
    'libactiverecord-ruby1.8',
    'puppetmaster',
    'rubygems' ]:
    ensure => present,
  }

  service { 'puppetmaster':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      File['puppet.conf'],
      $puppet::params::package,
    ],
  }

  tidy { '/var/lib/puppet/reports':
    age     => '1m',
    recurse => true,
    type    => 'mtime',
    matches => '*.yaml',
  }
}