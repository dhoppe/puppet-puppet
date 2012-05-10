class puppet {
  validate_string(hiera('host'))
  validate_string(hiera('dbadapter'))
  validate_string(hiera('dbpasswd'))
  validate_string(hiera('dbserver'))

  file { '/etc/default/puppet':
    owner   => root,
    group   => root,
    mode    => '0644',
    alias   => 'puppet',
    source  => 'puppet:///modules/puppet/common/etc/default/puppet',
    notify  => Service['puppet'],
    require => Package['puppet'],
  }

  file { '/etc/puppet/auth.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    alias   => 'auth.conf',
    content => template('puppet/common/etc/puppet/auth.conf.erb'),
    notify  => Service['puppet'],
    require => Package['puppet'],
  }

  file { '/etc/puppet/namespaceauth.conf':
    owner   => root,
    group   => root,
    mode    => '0644',
    alias   => 'namespaceauth.conf',
    content => template('puppet/common/etc/puppet/namespaceauth.conf.erb'),
    notify  => Service['puppet'],
    require => Package['puppet'],
  }

  puppet::config { '/etc/puppet/puppet.conf':
    config => 'agent',
    host   => hiera('host'),
  }

  package { [
    'puppet',
    'ruby' ]:
    ensure => present,
  }

  service { 'puppet':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      File['puppet'],
      File['namespaceauth.conf'],
      File['puppet.conf'],
      Package['puppet']
    ],
  }
}