define puppet::config(
  $config,
  $host,
  $dbadapter = undef,
  $dbpasswd  = undef,
  $dbserver  = undef
) {
  file { $name:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    alias   => 'puppet.conf',
    content => template("puppet/common/etc/puppet/puppet-${config}.conf.erb"),
    notify  => Service['puppet'],
    require => Package['puppet'],
  }
}