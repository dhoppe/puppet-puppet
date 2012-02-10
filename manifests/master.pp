class puppet::master inherits puppet {
	Puppet::Config["/etc/puppet/puppet.conf"] {
		config  => "master",
		notify  +> Service["puppetmaster"],
		require +> Package["puppetmaster"],
	}

	package { [
		"hiera",
		"hiera-puppet" ]:
		ensure   => present,
		provider => gem,
	}

	package { "puppetmaster":
		ensure => present,
	}

	service { "puppetmaster":
		enable     => true,
		ensure     => running,
		hasrestart => true,
		hasstatus  => true,
		require    => [
			File["puppet.conf"],
			Package["puppetmaster"]
		],
	}

	tidy { "/var/lib/puppet/reports":
		age     => "1m",
		recurse => true,
		type    => "mtime",
		matches => "*.yaml",
	}
}

# vim: tabstop=3