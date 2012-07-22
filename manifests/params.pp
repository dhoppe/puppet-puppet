class puppet::params {
  case $::lsbdistcodename {
    'lenny', 'squeeze', 'maverick', 'natty', 'precise': {
      $dbadapter = hiera('dbadapter')
      $dbpasswd  = hiera('dbpasswd')
      $dbserver  = hiera('dbserver')
      $host      = hiera('host')

      case $dbadapter {
        'mysql': {
          $package = [
            Package['libmysql-ruby'],
            Package['puppetmaster']
          ]
        }
        'postgresql': {
          $package = [
            Package['pg'],
            Package['puppetmaster']
          ]
        }
        default: {
          fail("Module ${module_name} does not support ${dbadapter}")
        }
      }
    }
    default: {
      fail("Module ${module_name} does not support ${::lsbdistcodename}")
    }
  }
}
