class puppet {
	define puppet::config($config = false, $host = false) {
		file { "$name":
			owner   => root,
			group   => root,
			mode    => 0644,
			alias   => "puppet.conf",
			content => template("puppet/common/etc/puppet/puppet-${config}.conf.erb"),
			notify  => Service["puppet"],
			require => Package["puppet"],			
		}
	}

	file { "/etc/default/puppet":
		owner   => root,
		group   => root,
		mode    => 0644,
		alias   => "puppet",
		source  => "puppet:///modules/puppet/common/etc/default/puppet",
		notify  => Service["puppet"],
		require => Package["puppet"],
	}

	file { "/etc/puppet/namespaceauth.conf":
		owner   => root,
		group   => root,
		mode    => 0644,
		alias   => "namespaceauth.conf",
		content => template("puppet/common/etc/puppet/namespaceauth.conf.erb"),
		notify  => Service["puppet"],
		require => Package["puppet"],
	}

	puppet::config { "/etc/puppet/puppet.conf":
		config => "agent",
		host   => hiera('host'),
	}

	package { [
		"puppet",
		"ruby" ]:
		ensure => present,
	}

	service { "puppet":
		enable     => true,
		ensure     => running,
		hasrestart => true,
		hasstatus  => true,
		require    => [
			File["puppet"],
			File["namespaceauth.conf"],
			File["puppet.conf"],
			Package["puppet"]
		],
	}
}

# vim: tabstop=3