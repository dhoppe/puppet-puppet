class puppet::master inherits puppet {
	$dbadapter = hiera('dbadapter')

	Puppet::Config["/etc/puppet/puppet.conf"] {
		config    => "master",
		dbadapter => hiera('dbadapter'),
		dbpasswd  => hiera('dbpasswd'),
		dbserver  => hiera('dbserver'),
		notify    +> Service["puppetmaster"],
		require   +> $dbadapter ? {
			mysql      => [
				Package["libmysql-ruby"],
				Package["puppetmaster"]
			],
			postgresql => [
				Package["pg"],
				Package["puppetmaster"]
			],
		}
	}

	if $dbadapter == "mysql" {
		package { "libmysql-ruby":
			ensure => present,
		}
	} elsif $dbadapter == "postgresql" {
		package { "pg":
			ensure   => present,
			provider => gem,
		}
	}

	package { [
		"hiera",
		"hiera-puppet" ]:
		ensure   => present,
		provider => gem,
	}

	package { [
		"puppetmaster",
		"rubygems" ]:
		ensure => present,
	}

	service { "puppetmaster":
		enable     => true,
		ensure     => running,
		hasrestart => true,
		hasstatus  => true,
		require    => $dbadapter ? {
			mysql      => [
				File["puppet.conf"],
				Package["libmysql-ruby"],
				Package["puppetmaster"]
			],
			postgresql => [
				File["puppet.conf"],
				Package["pg"],
				Package["puppetmaster"]
			],
		}
	}

	tidy { "/var/lib/puppet/reports":
		age     => "1m",
		recurse => true,
		type    => "mtime",
		matches => "*.yaml",
	}
}

# vim: tabstop=3